#region Copyright
// Copyright 2014 Myrcon Pty. Ltd.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#endregion

using System;
using NUnit.Framework;

namespace Potato.Net.Shared.Test {
    [TestFixture]
    public class PacketDispatchTest {

        /// <summary>
        /// Tests equality with another object with the same value.
        /// </summary>
        [Test]
        public void TestPacketDispatchEquality() {
            PacketDispatch dispatchA = new PacketDispatch() {
                Name = "equal"
            };

            PacketDispatch dispatchB = new PacketDispatch() {
                Name = "equal"
            };

            Assert.IsTrue(dispatchA.Equals(dispatchB));
        }

        /// <summary>
        /// Tests a comparison with null will not be true.
        /// </summary>
        [Test]
        public void TestPacketDispatchEqualityAgainstNull() {
            PacketDispatch dispatch = new PacketDispatch() {
                Name = "equal"
            };

            Assert.IsFalse(dispatch.Equals(null));
        }

        /// <summary>
        /// Tests a comparison with null will not be true.
        /// </summary>
        [Test]
        public void TestPacketDispatchEqualityCastToObjectAgainstNull() {
            Object dispatch = new PacketDispatch() {
                Name = "equal"
            };

            Assert.IsFalse(dispatch.Equals(null));
        }

        /// <summary>
        /// Tests that a dispatch will be equal against a reference to itself.
        /// </summary>
        [Test]
        public void TestPacketDispatchEqualityAgainstReferenceToSameObject() {
            PacketDispatch dispatchA = new PacketDispatch() {
                Name = "equal"
            };

            PacketDispatch dispatchB = dispatchA;

            Assert.IsTrue(dispatchA.Equals(dispatchB));
        }

        /// <summary>
        /// Tests that a dispatch will be equal against a reference to itself.
        /// </summary>
        [Test]
        public void TestPacketDispatchEqualityAgainstReferenceToSameObjectCastToObject() {
            PacketDispatch dispatchA = new PacketDispatch() {
                Name = "equal"
            };

            Object dispatchB = dispatchA;

            Assert.IsTrue(dispatchA.Equals(dispatchB));
        }

        /// <summary>
        /// Tests that a comparison with a different type will come back as false.
        /// </summary>
        [Test]
        public void TestPacketDispatchEqualityAgainstDifferenceType() {
            PacketDispatch dispatchA = new PacketDispatch() {
                Name = "equal"
            };

            String dispatchB = "equal";

            Assert.IsFalse(dispatchA.Equals(dispatchB));
        }

        /// <summary>
        /// Tests the same value in two different objects with have the same hash codes.
        /// </summary>
        [Test]
        public void TestPacketDispatchEqualityHashCode() {
            PacketDispatch dispatchA = new PacketDispatch() {
                Name = "equal"
            };

            PacketDispatch dispatchB = new PacketDispatch() {
                Name = "equal"
            };

            Assert.AreEqual(dispatchA.GetHashCode(), dispatchB.GetHashCode());
        }

        /// <summary>
        /// Tests that different values will yield a different hash code.
        /// </summary>
        [Test]
        public void TestPacketDispatchNotEqualHashCode() {
            PacketDispatch dispatchA = new PacketDispatch() {
                Name = "equalA"
            };

            PacketDispatch dispatchB = new PacketDispatch() {
                Name = "equalB"
            };

            Assert.AreNotEqual(dispatchA.GetHashCode(), dispatchB.GetHashCode());
        }
    }
}
