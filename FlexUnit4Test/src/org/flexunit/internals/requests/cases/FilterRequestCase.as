/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.flexunit.internals.requests.cases
{
	import org.flexunit.Assert;
	import org.flexunit.internals.requests.FilterRequest;
	import org.flexunit.internals.runners.ErrorReportingRunner;
	import org.flexunit.runner.IDescription;
	import org.flexunit.runner.manipulation.NoTestsRemainException;
	import org.flexunit.runner.manipulation.mocks.FilterMock;
	import org.flexunit.runner.mocks.RequestMock;
	import org.flexunit.runner.mocks.RunnerMock;

	public class FilterRequestCase
	{
		//TODO: Ensure that these tests and this test case are being implemented correctly
		
		protected var filterRequest:FilterRequest;
		protected var requestMock:RequestMock;
		protected var filterMock:FilterMock;
		
		[Before(description="Create an instance of FilterRequest")]
		public function createFilterRequest():void {
			requestMock = new RequestMock();
			filterMock = new FilterMock( shouldRunTest, describeTest );
			filterRequest = new FilterRequest(requestMock, filterMock);
		}
		
		[After(description="Remove the reference to the instance of the FilterRequest")]
		public function destroyFilterRequest():void {
			filterRequest = null;
			requestMock = null;
			filterMock = null;
		}
		
		[Test(description="Ensure the get iRunner function returns an IRunner when no exception is thrown")]
		public function getIRunnerTest():void {
			var runnerMock:RunnerMock = new RunnerMock();
			requestMock.mock.property("iRunner").returns(runnerMock);
			
			filterMock.mock.method("apply").withArgs(runnerMock).once;
			
			Assert.assertEquals( runnerMock, filterRequest.iRunner );
			
			filterMock.mock.verify();
		}
		
		[Test(description="Ensure the get iRunner function returns an ErrorReportingRunner if a NoTestsRemainException is thrown")]
		public function getIRunnerNoTestsExceptionTest():void {
			var runnerMock:RunnerMock = new RunnerMock();
			var noTestsRemainException:NoTestsRemainException = new NoTestsRemainException();
			requestMock.mock.property("iRunner").returns(runnerMock);
			
			filterMock.mock.method("apply").withArgs(runnerMock).once.andThrow(noTestsRemainException);
			
			Assert.assertTrue( filterRequest.iRunner is ErrorReportingRunner );
			
			filterMock.mock.verify();
		}
		
		[Ignore("Currently, there it is not possible to get to a case where that return null will be hit")]
		[Test(description="Ensure the get iRunner function returns null if an exception that isn't a NoTestsRemainException is thrown")]
		public function getIRunnerNullExceptionTest():void {
			var runnerMock:RunnerMock = new RunnerMock();
			var error:Error = new Error();
			requestMock.mock.property("iRunner").returns(runnerMock);
			
			filterMock.mock.method("apply").withArgs(runnerMock).once.andThrow(error);
			
			Assert.assertNull( filterRequest.iRunner );
			
			filterMock.mock.verify();
		}

		public function shouldRunTest( description:IDescription ):Boolean {
			// do something
			return true;
		}
		
		public function describeTest( description:IDescription ):String {
			// do something
			return "any";
		}		
	}
}