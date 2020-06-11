package com.am.ds.raft.rpc

import com.esotericsoftware.kryo.io.{Input, Output}
import com.esotericsoftware.kryo.{Kryo, KryoSerializable}

/**
 * Description goes here
 * @author ashrith 
 */
case class JointConfiguration(var oldBindings: List[String], var newBindings: List[String]) extends WriteCommand[Boolean] with KryoSerializable with ClusterConfigurationCommand {
  def write(kryo: Kryo, output: Output) = {
    output.writeString(oldBindings.mkString(","))
    output.writeString(newBindings.mkString(","))
  }

  def read(kryo: Kryo, input: Input) = {
    oldBindings = input.readString().split(",").toList
    newBindings = input.readString().split(",").toList
  }
}
