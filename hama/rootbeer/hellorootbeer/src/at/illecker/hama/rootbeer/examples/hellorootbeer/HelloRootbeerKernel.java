package at.illecker.hama.rootbeer.examples.hellorootbeer;

import edu.syr.pcpratts.rootbeer.runtime.Kernel;

public class HelloRootbeerKernel implements Kernel {

	private long m_iterations;
	private double result = 0;

	public HelloRootbeerKernel(long iterations) {
		m_iterations = iterations;
	}

	public void gpuMethod() {
		result = m_iterations;
	}

	public double getResult() {
		return result;
	}

	public static void main(String[] args) {
		// Dummy constructor invocation to keep Kernel constructor
		new HelloRootbeerKernel(1);
	}
}
