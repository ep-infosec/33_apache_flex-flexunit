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
package org.flexunit.runner.manipulation.cases
{
	import flex.lang.reflect.metadata.MetaDataAnnotation;
	
	import org.flexunit.Assert;
	import org.flexunit.runner.Description;
	import org.flexunit.runner.manipulation.OrderArgumentSorter;

	public class MetadataSorterCase
	{
		//TODO: Are these test correctly testing the MetadataSorter class
		private var metaDataSorter:OrderArgumentSorter;
		
		protected var lowerXML:XML = new XML(
			<method>
				<metadata name="Test">
					<arg key="order" value="42"/>
					<arg key="description" value="Description A"/>
				</metadata>
				<metadata name="__go_to_definition_help">
				  <arg key="pos" value="719"/>
				</metadata>
			</method>);
		
		protected var noOrderXML:XML = new XML(
			<method>
				<metadata name="Test">
					<arg key="description" value="Description A"/>
				</metadata>
				<metadata name="__go_to_definition_help">
				  <arg key="pos" value="719"/>
				</metadata>
			</method>);
		
		protected var higherXML:XML = new XML(
			<method>
				<metadata name="Test">
					<arg key="order" value="1729"/>
					<arg key="description" value="Description B"/>
				</metadata>
				<metadata name="__go_to_definition_help">
				  <arg key="pos" value="720"/>
				</metadata>
			</method>);
		
		private static function convertToMetaDataAnnotations( metaXML:XMLList ):Array {
			var ar:Array = new Array();
			for ( var i:int=0; i<metaXML.length(); i++ )  {
				ar.push( new MetaDataAnnotation( metaXML[ i ] ) );
			}
			
			return ar;
		} 
		
		[Before]
		public function setupSorter():void {
			metaDataSorter = new OrderArgumentSorter();
		}

		protected var noOrderArray:Array = convertToMetaDataAnnotations( noOrderXML.metadata );
		
		protected var lowerArray:Array = convertToMetaDataAnnotations( lowerXML.metadata );
			
		protected var higherArray:Array = convertToMetaDataAnnotations( higherXML.metadata );
		
		[Test(description="Ensure the MetadataSorter returns a 0 when both IDescriptions contain a null XMLList")]
		public function bothDescNullMetadataTest():void {
			var o1:Description = new Description("a", null);
			var o2:Description = new Description("b", null);
			
			Assert.assertEquals(metaDataSorter.compare(o1, o2), 0 );
		}
		
		[Test(description="Ensure the MetadataSorter returns a -1 when only the second IDescription contains a XMLList")]
		public function firstDescNullMetadataTest():void {
			var o1:Description = new Description("a", null);
			var o2:Description = new Description("b", higherArray);
			
			Assert.assertEquals(metaDataSorter.compare(o1, o2), -1 );
		}
		
		[Test(description="Ensure the MetadataSorter returns a 1 when only the first IDescription contains a XMLList")]
		public function secondDescNullMetadataTest():void {
			var o1:Description = new Description("a", higherArray);
			var o2:Description = new Description("b", null);
			
			Assert.assertEquals(metaDataSorter.compare(o1, o2), 1 );
		}
		
		[Test(description="Ensure the MetadataSorter returns a 0 when both IDescription contains an XMLList with equal ordering")]
		public function bothDescMetadataEqualTest():void {
			var o1:Description = new Description("a", lowerArray);
			var o2:Description = new Description("b", lowerArray);
			
			Assert.assertEquals(metaDataSorter.compare(o1, o2), 0 );
		}
		
		[Test(description="Ensure the MetadataSorter returns a 1 when the first IDescription contains an XMLList with a greater order")]
		public function firstDescMetadataGreaterTest():void {
			var o1:Description = new Description("a", higherArray);
			var o2:Description = new Description("b", lowerArray);
			
			Assert.assertEquals(metaDataSorter.compare(o1, o2), 1 );
		}
		
		[Test(description="Ensure the MetadataSorter returns a -1 when the second IDescription contains an XMLList with a greater order")]
		public function secondDescMetadataGreaterTest():void {
			var o1:Description = new Description("a", lowerArray);
			var o2:Description = new Description("b", higherArray);
			
			Assert.assertEquals(metaDataSorter.compare(o1, o2), -1 );
		}
	
		[Test(description="Ensure the MetadataSorter returns a -1 when the second IDescription contains an XMLList with a greater order")]
		public function firstNoOrderMetadataGreaterTest():void {
			var o1:Description = new Description("a", noOrderArray);
			var o2:Description = new Description("b", lowerArray);
			
			Assert.assertEquals(metaDataSorter.compare(o1, o2), -1 );
		}

		[Test(description="Ensure the MetadataSorter returns a 1 when the first IDescription contains an XMLList with a greater order")]
		public function firstNoOrderMetadataLessTest():void {
			var o1:Description = new Description("a", lowerArray);
			var o2:Description = new Description("b", noOrderArray);
			
			Assert.assertEquals(metaDataSorter.compare(o1, o2), 1 );
		}
	}
}