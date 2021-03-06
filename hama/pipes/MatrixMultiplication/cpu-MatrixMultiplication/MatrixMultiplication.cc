/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "hama/Pipes.hh"
#include "hama/TemplateFactory.hh"
#include "hadoop/StringUtils.hh"
#include "DenseDoubleVector.hh"

#include <time.h>
#include <math.h>
#include <string>
#include <iostream>
#include <sstream>

using std::string;
using std::vector;
using std::cout;

using HamaPipes::BSP;
using HamaPipes::BSPJob;
using HamaPipes::Partitioner;
using HamaPipes::BSPContext;
using namespace HadoopUtils;

using math::DenseDoubleVector;

class MatrixMultiplicationBSP: public BSP<int,string,int,string,string> {
private:
  string masterTask;
  int seqFileID;
  string HAMA_MAT_MULT_B_PATH;
public:
  MatrixMultiplicationBSP(BSPContext<int,string,int,string,string>& context) {
    seqFileID = 0;
    HAMA_MAT_MULT_B_PATH = "hama.mat.mult.B.path";
  }
  
  void setup(BSPContext<int,string,int,string,string>& context) {
    // Choose one as a master
    masterTask = context.getPeerName(context.getNumPeers() / 2);
    
    reopenMatrixB(context);
  }
  
  void bsp(BSPContext<int,string,int,string,string>& context) {
    
    int a_row_key = 0;
    string a_row_vector_str;
    // while for each row of matrixA
    while(context.readNext(a_row_key, a_row_vector_str)) {
      cout << "a_row_key: " << a_row_key << " - a_row_vector_str: " << a_row_vector_str << "\n";
      
      DenseDoubleVector *a_row_vector = new DenseDoubleVector(a_row_vector_str);
      int b_col_key = 0;
      string b_col_vector_str;
      
      // dynamic column values, depend on matrix B cols
      vector<double> col_values;
      
      // while for each col of matrixB
      while (context.sequenceFileReadNext<int,string>(seqFileID, b_col_key, b_col_vector_str)) {
        
        cout << "b_col_key: " << b_col_key << " - b_col_vector_str: " << b_col_vector_str << "\n";
        
        DenseDoubleVector *b_col_vector = new DenseDoubleVector(b_col_vector_str);
        
        double dot = a_row_vector->dot(b_col_vector);
        
        col_values.push_back(dot);
      }
      
      DenseDoubleVector *col_values_vector = new DenseDoubleVector(col_values.size(), col_values.data());
      
      // Submit one calculated row
      // :key:value1,value2,value3
      std::stringstream message;
      message << ":" << a_row_key << ":" << col_values_vector->toString();
      context.sendMessage(masterTask, message.str());
      
      reopenMatrixB(context);
    }
    
    context.sequenceFileClose(seqFileID);
    context.sync();
  }
  
  void cleanup(BSPContext<int,string,int,string,string>& context) {
    if (context.getPeerName().compare(masterTask)==0) {
      cout << "I'm the MasterTask fetch results!\n";
      
      int msgCount = context.getNumCurrentMessages();
      cout << "MasterTask fetches " << msgCount << " messages!\n";
      
      for (int i=0; i<msgCount; i++) {
        
        // :key:value1,value2,value3
        string received = context.getCurrentMessage();
        string key_value_str = received.substr(1);
        int pos = (int)key_value_str.find(received.substr(0,1));
        int key = HadoopUtils::toInt(key_value_str.substr(0,pos));
        string values = key_value_str.substr(pos+1);
        
        cout << "RECEIVED MSG: key:" << key << " value: " << values.substr(0,20) << "\n";
        
        context.write(key, values);
      }
    }
  }
  
  void reopenMatrixB(BSPContext<int,string,int,string,string>& context) {
    if (seqFileID!=0) {
      context.sequenceFileClose(seqFileID);
    }
    
    const BSPJob* job = context.getBSPJob();
    string path = job->get(HAMA_MAT_MULT_B_PATH);
    
    //cout << "sequenceFileOpen path: " << path << "\n";
    seqFileID = context.sequenceFileOpen(path, "r",
                                         "org.apache.hadoop.io.IntWritable",
                                         "org.apache.hama.commons.io.PipesVectorWritable");
  }
  
};

class MatrixRowPartitioner: public Partitioner<int,string> {
public:
  MatrixRowPartitioner(BSPContext<int,string,int,string,string>& context) { }
  
  int partition(const int& key, const string& value, int32_t num_tasks) {
    cout << "partition key: " << key << " value: " << value.substr(0,10) << "..." << " num_tasks: "<< num_tasks <<"\n";
    return key % num_tasks;
  }
};

int main(int argc, char *argv[]) {
  return HamaPipes::runTask<int,string,int,string,string>(HamaPipes::TemplateFactory<MatrixMultiplicationBSP,int,string,int,string,string,MatrixRowPartitioner>());
}
