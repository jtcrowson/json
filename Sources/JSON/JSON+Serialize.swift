import Core
import Foundation

extension JSON {
    public func serialize(prettyPrint: Bool = false, sortedKeys: Bool = false) throws -> Bytes {
        switch wrapped {
        case .array, .object:
            return try _nsSerialize(prettyPrint: prettyPrint, sortedKeys: sortedKeys)
        case .bool(let b):
            return b ? [.t, .r, .u, .e] : [.f, .a, .l, .s, .e]
        case .bytes(let b):
            let encoded = b.base64Encoded
            return [.quote] + encoded + [.quote]
        case .date, .string:
            let bytes = string?.escaped().makeBytes() ?? []
            return [.quote] + bytes + [.quote]
        case .number:
            return string?.makeBytes() ?? []
        case .null:
            return [.n, .u, .l, .l]
        }
    }
    
    private func _nsSerialize(prettyPrint: Bool, sortedKeys: Bool) throws -> Bytes {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrint {
            options.insert(.prettyPrinted)
        }
        if #available(OSX 10.13, *) {
            if sortedKeys {
                options.insert(.sortedKeys)
            }
        }
        

        let data = try JSONSerialization.data(
            withJSONObject: wrapped.foundationJSON,
            options: options
        )
        return data.makeBytes()
    }
}

extension String {
    fileprivate func escaped() -> String {
        var string = ""
        string.reserveCapacity(string.characters.count)
        
        for char in self.characters {
            switch char {
            case "\"":
                string += "\\\""
            case "\\":
                string += "\\\\"
            case "\t":
                string += "\\t"
            case "\n":
                string += "\\n"
            case "\r":
                string += "\\r"
            default:
                string.append(char)
            }
        }
        
        return string
    }
}
