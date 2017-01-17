//
//  KeyCode.swift
//  SwiftShortcut
//
//  Created by Shad Sharma on 12/23/16.
//  Copyright © 2016 Shad Sharma. All rights reserved.
//
//  This class defines functions for converting between key press events and human readable strings
//

import AppKit
import Carbon

class KeyCode: NSObject {
    let keyCode: Int
    let modifierFlags: NSEventModifierFlags
    
    init(keyCode: Int, modifierFlags: NSEventModifierFlags) {
        self.keyCode = keyCode
        self.modifierFlags = modifierFlags
    }
    
    static func fromEvent(event: NSEvent) -> KeyCode {
        return KeyCode(keyCode: Int(event.keyCode), modifierFlags: event.modifierFlags)
    }
    
    override var description: String {
        return modifierFlagsString + keyCodeString
    }
    
    var keyCodeString: String {
        return keyCodeToString(keyCode: keyCode)
    }
    
    var modifierFlagsString: String {
        return modifierFlagsToString(modifierFlags: modifierFlags)
    }
}

func keyEventToString(keyCode: Int, modifierFlags: NSEventModifierFlags) -> String {
    return modifierFlagsToString(modifierFlags: modifierFlags) + keyCodeToString(keyCode: keyCode)
}

func modifierFlagsToString(modifierFlags: NSEventModifierFlags) -> String {
    var result = ""
    
    if modifierFlags.contains(.control) {
        result.append("⌃")
    }
    
    if modifierFlags.contains(.option) {
        result.append("⌥")
    }
    
    if modifierFlags.contains(.shift) {
        result.append("⇧")
    }
    
    if modifierFlags.contains(.command) {
        result.append("⌘")
    }
    
    return result
}

func keyCodeToString(keyCode: Int) -> String {
    switch keyCode {
    case kVK_F1: return "\u{F704}"
    case kVK_F2: return "\u{F705}"
    case kVK_F3: return "\u{F706}"
    case kVK_F4: return "\u{F707}"
    case kVK_F5: return "\u{F708}"
    case kVK_F6: return "\u{F709}"
    case kVK_F7: return "\u{F70a}"
    case kVK_F8: return "\u{F70b}"
    case kVK_F9: return "\u{F70c}"
    case kVK_F10: return "\u{F70d}"
    case kVK_F11: return "\u{F70e}"
    case kVK_F12: return "\u{F70f}"
    case kVK_F13: return "\u{F710}"
    case kVK_F14: return "\u{F711}"
    case kVK_F15: return "\u{F712}"
    case kVK_F16: return "\u{F713}"
    case kVK_F17: return "\u{F714}"
    case kVK_F18: return "\u{F715}"
    case kVK_F19: return "\u{F716}"
    case kVK_Space: return "\u{0020}"
    case kVK_Escape: return "\u{238B}" // ⎋
    case kVK_Delete: return "\u{232B}" // ⌫
    case kVK_ForwardDelete: return "\u{2326}" // ⌦
    case kVK_LeftArrow: return "\u{2190}" // ←
    case kVK_RightArrow: return "\u{2192}" // →
    case kVK_UpArrow: return "\u{2191}" // ↑
    case kVK_DownArrow: return "\u{2193}" // ↓
    case kVK_Help: return "\u{003F}" // ?
    case kVK_PageUp: return "\u{21DE}" // ⇞
    case kVK_PageDown: return "\u{21DF}" // ⇟
    case kVK_Tab: return "\u{21E5}" // ⇥
    case kVK_Return: return "\u{21A9}" // ↩
        
    // Keypad
    case kVK_ANSI_Keypad0: return "0"
    case kVK_ANSI_Keypad1: return "1"
    case kVK_ANSI_Keypad2: return "2"
    case kVK_ANSI_Keypad3: return "3"
    case kVK_ANSI_Keypad4: return "4"
    case kVK_ANSI_Keypad5: return "5"
    case kVK_ANSI_Keypad6: return "6"
    case kVK_ANSI_Keypad7: return "7"
    case kVK_ANSI_Keypad8: return "8"
    case kVK_ANSI_Keypad9: return "9"
    case kVK_ANSI_KeypadDecimal: return "."
    case kVK_ANSI_KeypadMultiply: return "*"
    case kVK_ANSI_KeypadPlus: return "+"
    case kVK_ANSI_KeypadClear: return "\u{2327}" // ⌧
    case kVK_ANSI_KeypadDivide: return "/"
    case kVK_ANSI_KeypadEnter: return "\u{2305}" // ⌅
    case kVK_ANSI_KeypadMinus: return "–"
    case kVK_ANSI_KeypadEquals: return "="
        
    // Hardcode
    case 119: return "↘"
    case 115: return "↖"
    default:
        if let inputSource = TISCopyCurrentASCIICapableKeyboardLayoutInputSource(),
            let layoutDataRef = TISGetInputSourceProperty(inputSource.takeRetainedValue(), kTISPropertyUnicodeKeyLayoutData) {
            let layoutData = unsafeBitCast(layoutDataRef, to: CFData.self)
            let layout: UnsafePointer<UCKeyboardLayout> = unsafeBitCast(CFDataGetBytePtr(layoutData), to: UnsafePointer<UCKeyboardLayout>.self)
            
            var deadKeyState = UInt32(0)
            var length = Int(0)
            var chars: [UniChar] = [0,0,0,0]
            
            let error = UCKeyTranslate(layout, UInt16(keyCode), UInt16(kUCKeyActionDisplay), 0, UInt32(LMGetKbdType()), OptionBits(kUCKeyTranslateNoDeadKeysMask), &deadKeyState, chars.count, &length, &chars)
            
            if error == noErr && length > 0 {
                return String(utf16CodeUnits: chars, count: 1).uppercased()
            }
        }
        
        return ""
    }
}
