// Auto-generated. Do not edit!

// (in-package openmv_transport.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;

//-----------------------------------------------------------

class Line {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.rho_output = null;
      this.theta_output = null;
      this.value = null;
    }
    else {
      if (initObj.hasOwnProperty('rho_output')) {
        this.rho_output = initObj.rho_output
      }
      else {
        this.rho_output = 0.0;
      }
      if (initObj.hasOwnProperty('theta_output')) {
        this.theta_output = initObj.theta_output
      }
      else {
        this.theta_output = 0.0;
      }
      if (initObj.hasOwnProperty('value')) {
        this.value = initObj.value
      }
      else {
        this.value = false;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type Line
    // Serialize message field [rho_output]
    bufferOffset = _serializer.float32(obj.rho_output, buffer, bufferOffset);
    // Serialize message field [theta_output]
    bufferOffset = _serializer.float32(obj.theta_output, buffer, bufferOffset);
    // Serialize message field [value]
    bufferOffset = _serializer.bool(obj.value, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type Line
    let len;
    let data = new Line(null);
    // Deserialize message field [rho_output]
    data.rho_output = _deserializer.float32(buffer, bufferOffset);
    // Deserialize message field [theta_output]
    data.theta_output = _deserializer.float32(buffer, bufferOffset);
    // Deserialize message field [value]
    data.value = _deserializer.bool(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 9;
  }

  static datatype() {
    // Returns string type for a message object
    return 'openmv_transport/Line';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '589598a53c23406a8280a9b28c65982e';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    float32 rho_output
    float32 theta_output
    bool value
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new Line(null);
    if (msg.rho_output !== undefined) {
      resolved.rho_output = msg.rho_output;
    }
    else {
      resolved.rho_output = 0.0
    }

    if (msg.theta_output !== undefined) {
      resolved.theta_output = msg.theta_output;
    }
    else {
      resolved.theta_output = 0.0
    }

    if (msg.value !== undefined) {
      resolved.value = msg.value;
    }
    else {
      resolved.value = false
    }

    return resolved;
    }
};

module.exports = Line;
