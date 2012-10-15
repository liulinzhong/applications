#include "hama/Pipes.hh"
#include "hama/TemplateFactory.hh"
#include "hadoop/StringUtils.hh"
#include "DenseDoubleVector.hh"

#include <time.h>
#include <math.h>
#include <string>
#include <iostream>

using std::string;
using std::cout;

using HamaPipes::BSP;
using HamaPipes::BSPJob;
using HamaPipes::Partitioner;
using HamaPipes::BSPContext;
using namespace HadoopUtils;
using math::DenseDoubleVector;

class MatrixMultiplicationBSP: public BSP {
private:
    string masterTask;
    int seqFileID;
    string HAMA_MAT_MULT_B_PATH;
public:
  MatrixMultiplicationBSP(BSPContext& context) { 
    seqFileID = 0;
    HAMA_MAT_MULT_B_PATH = "hama.mat.mult.B.path";
  }

  void bsp(BSPContext& context) {
      
    string aRowKey;
    string aRowVectorStr;
    // while for each row of matrixA
    while(context.readNext(aRowKey, aRowVectorStr)) {
      cout << "aRowKey: " << aRowKey << " - aRowVectorStr: " << aRowVectorStr << "\n";
        
      DenseDoubleVector *aRowVector = new DenseDoubleVector(aRowVectorStr);
      DenseDoubleVector *colValues = NULL;
        
      string bColKey;
      string bColVectorStr;
        
      // while for each col of matrixB
      while (context.sequenceFileReadNext(seqFileID,bColKey,bColVectorStr)) {
        
          cout << "bColKey: " << bColKey << " - bColVectorStr: " << bColVectorStr << "\n";
          
          DenseDoubleVector *bColVector = new DenseDoubleVector(bColVectorStr);
          
          if (colValues == NULL)
             colValues = new DenseDoubleVector(bColVector->getDimension());
          
          double dot = aRowVector->dot(bColVector);
          
          colValues->set(toInt(bColKey), dot);
      }
      
      break;
      context.sendMessage(masterTask, aRowKey); //aRowKey << ":" << colValues
        
      reopenMatrixB(context);
    }
    context.sequenceFileClose(seqFileID);
      
    context.sync();
  }
    
  void setup(BSPContext& context) {
      // Choose one as a master
      masterTask = context.getPeerName(context.getNumPeers() / 2);
      
      reopenMatrixB(context);
  }
    
  void cleanup(BSPContext& context) {
      if (context.getPeerName().compare(masterTask)==0) {
          cout << "I'm the MasterTask fetch results!\n";
          
          int msgCount = context.getNumCurrentMessages();
          cout << "MasterTask fetches " << msgCount << " results!\n";
          
          for (int i=0; i<msgCount; i++) {
              
              string received = context.getCurrentMessage();
              
              cout << "RECEIVED MSG: " << received << "\n";
              
              //peer.write(
              //           new IntWritable(currentMatrixRowMessage.getRowIndex()),
              //           currentMatrixRowMessage.getColValues());
              
              //context.write("Sum", toString(sum));
          }
      }
  }
    
  void reopenMatrixB(BSPContext& context) {
    if (seqFileID!=0)
      context.sequenceFileClose(seqFileID);

    const BSPJob* job = context.getBSPJob();
    string path = job->get(HAMA_MAT_MULT_B_PATH);
      
    cout << "sequenceFileOpen path: " << path << "\n";
    seqFileID = context.sequenceFileOpen(path,"r",
                "org.apache.hadoop.io.IntWritable",
                "de.jungblut.writable.VectorWritable");
    
  } 
    
};



class MatrixRowPartitioner: public Partitioner {
public:
    MatrixRowPartitioner(BSPContext& context) { }
        
    int partition(const string& key,const string& value, int32_t numTasks) {
      //cout << "partition key: " << key << " value: " << value.substr(0,10) << "..." << " numTasks: "<< numTasks <<"\n";
      return toInt(key) % numTasks;
    }
};

int main(int argc, char *argv[]) {
  return HamaPipes::runTask(HamaPipes::TemplateFactory<MatrixMultiplicationBSP,MatrixRowPartitioner>());
}
