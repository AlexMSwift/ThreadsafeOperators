// Created by Alex Moore on 10/01/19.

import Foundation

// 32 and 64 bit signed types
infix operator +=! { associativity right precedence 90 }
infix operator -=! { associativity right precedence 90 }
postfix operator ++! {}
postfix operator --! {}

// unsigned 32 bit types for win32 and GPU inter-op, mainly.
infix operator |=! { associativity right precedence 90 }
infix operator &=! { associativity right precedence 90 }
infix operator ^=! { associativity right precedence 90 }

// where rhs is dependent on lhs
infix operator =! { associativity right precedence 90 }

// MARK: -

func +=!(inout lhs: Int64, rhs: Int64) -> Int64 {
  OSAtomicAdd64(rhs, &lhs)
}

func +=!(inout lhs: Int32, rhs: Int32) -> Int32 {
  OSAtomicAdd32(rhs, &lhs)
}

func -=!(inout lhs: Int64, rhs: Int64) -> Int64 {
  lhs +=! -rhs
}

func -=!(inout lhs: Int32, rhs: Int32) -> Int32 {
  lhs +=! -rhs
}

postfix func ++!(inout value: Int64) -> Int64 {
  OSAtomicIncrement64(&value)
}

postfix func ++!(inout value: Int32) -> Int32 {
  OSAtomicIncrement32(&value)
}

postfix func --!(inout value: Int64) -> Int64 {
  OSAtomicDecrement64(&value)
}

postfix func --!(inout value: Int32) -> Int32 {
  OSAtomicDecrement32(&value)
}

func |=!(inout lhs: UInt32, rhs: UInt32) -> UInt32 {
  UInt32(OSAtomicOr32(rhs, &lhs))
}

func &=!(inout lhs: UInt32, rhs: UInt32) -> UInt32 {
  UInt32(OSAtomicAnd32(rhs, &lhs))
}

func ^=!(inout lhs: UInt32, rhs: UInt32) -> UInt32 {
  UInt32(OSAtomicXor32(rhs, &lhs))
}

func =!(inout lhs: Int32, rhs: @autoclosure () -> Int32) -> Int32 {
  var success: Bool
  var newValue: Int32!
  
  do {
    let original = lhs;
    newValue = rhs()
    success = OSAtomicCompareAndSwap32(original, newValue, &lhs)
  } while(!success);
  
  return newValue
}

func =!(inout lhs: Int64, rhs: @autoclosure () -> Int64) -> Int64 {
  var success: Bool
  var newValue: Int64!
  
  do {
    let original = lhs;
    newValue = rhs()
    success = OSAtomicCompareAndSwap64(original, newValue, &lhs)
  } while(!success);
  
  return newValue
}

func =!(inout lhs: Int, rhs: @autoclosure () -> Int) -> Int {
  var success: Bool
  var newValue: Int!
  
  do {
    let original = lhs;
    newValue = rhs()
    success = OSAtomicCompareAndSwapLong(original, newValue, &lhs)
  } while(!success);
  
  return newValue
}

func =!(inout lhs: UnsafeMutablePointer<Void>,
              rhs: @autoclosure () -> UnsafeMutablePointer<Void>
       ) -> UnsafeMutablePointer<Void> {
  var success: Bool
  var newValue: UnsafeMutablePointer<Void>!
  
  do {
    let original = lhs;
    newValue = rhs()
    success = OSAtomicCompareAndSwapPtr(original, newValue, &lhs)
  } while(!success);
  
  return newValue
}
