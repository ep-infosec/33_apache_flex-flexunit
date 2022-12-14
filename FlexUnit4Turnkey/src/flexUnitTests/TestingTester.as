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
package flexUnitTests
{
	import flashx.textLayout.debug.assert;
	
	import flexunit.framework.TestCase;
	
	public class TestingTester extends TestCase
	{
		// please note that all test methods should start with 'test' and should be public
		
		public function TestingTester(methodName:String=null)
		{
			//TODO: implement function
			super(methodName);
		}
		
		//This method will be called before every test function
		override public function setUp():void
		{
			//TODO: implement function
			super.setUp();
		}
		
		//This method will be called after every test function
		override public function tearDown():void
		{
			//TODO: implement function
			super.tearDown();
		}
		
		/* sample test method*/
		[Test]
		public function testSampleMethod():void
		{
			// Add your test logic here
			fail("Test method Not yet implemented");
		}
		[Ignore]
		public function testPassMethod():void
		{
			// Add your test logic here
			
		}
	}
}