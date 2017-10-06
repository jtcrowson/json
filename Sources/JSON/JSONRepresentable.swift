public protocol JSONRepresentable {
    func makeJSON() throws -> JSON
}

extension JSONRepresentable {
    func makeJSONIncluding(keys: [String]) throws -> JSON {
        let json = try self.makeJSON()
        var newJSON = JSON()
        for key in keys {
            let value: JSON = try json.get(key)
            try newJSON.set(key, value)
        }
        return newJSON
    }
    
    func makeJSONExcluding(keys: [String]) throws -> JSON {
        var json = try self.makeJSON()
        for key in keys {
            json.removeKey(key)
        }
        return json
    }
}

public protocol JSONInitializable {
    init(json: JSON) throws
}

public protocol JSONConvertible: JSONRepresentable, JSONInitializable {}

extension JSON: JSONRepresentable {
    public func makeJSON() -> JSON {
        return self
    }

    public init(json: JSON) {
        self = json
    }
}
