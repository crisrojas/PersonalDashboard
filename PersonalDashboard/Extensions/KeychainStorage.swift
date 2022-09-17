//
//  KeychainStorage.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 16/09/2022.
//

import SwiftUI

/*
 
 @todo:
 
- Make this property wrapper observable in a way that will behave as AppStorage
- Stop using appStorage for storing current TogglUser !
 */
@propertyWrapper
struct KeychainStorage<T: Codable>: DynamicProperty {
  
  typealias Value = T
  let key: KeychainKey
  
  
  @State private var value: Value?
  var wrappedValue: Value? {
    
    get  { value }
    
    nonmutating set {
      
      value = newValue
      
      do {
        let encoded = try JSONEncoder().encode(value)
        keychain.set(encoded, forKey: key.rawValue)
        
      } catch {
        keychain.delete(key)
      }
    }
  }
  
  
  var projectedValue: Binding<Value?> {
    Binding(get: { wrappedValue }, set: { wrappedValue = $0 })
  }
  
  init(wrappedValue: Value? = nil, _ key: KeychainKey) {
    
    self.key = key
    
    var initialValue = wrappedValue
    
    do {
      
      if let data = keychain.getData(key.rawValue) {
        let decoded = try jsonDecoder.decode(Value.self, from: data)
        initialValue = decoded
      } else {
        initialValue = nil
      }
      
    } catch let error {
      
      print("[KeychainStorage] Keychain().get(\(key)) - \(error.localizedDescription)")
    }
    
    self._value = State<Value?>(initialValue: initialValue)
  }
}
