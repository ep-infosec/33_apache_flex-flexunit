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
package org.flexunit.runner.notification.mocks
{
	import com.anywebcam.mock.Mock;
	
	import org.flexunit.runner.IDescription;
	import org.flexunit.runner.notification.Failure;
	
	public class FailureMock extends Failure
	{
		public var mock:Mock;
		
		override public function get testHeader():String {
			return mock.testHeader;
		}
		
		override public function get description():IDescription {
			return mock.description;
		}
		
		override public function get exception():Error {
			return mock.exception;	
		}
		
		override public function toString():String {
			return mock.toString();
		}
		
		override public function get message():String {
			return mock.message;
		}
		
		override public function get stackTrace():String {
			return mock.stackTrace;	
		}
		
		//TODO: How the the constructor for the mock object be handled
		public function FailureMock(description:IDescription = null, exception:Error = null)
		{
			mock = new Mock( this );
			
			super(description, exception);
		}
	}
}