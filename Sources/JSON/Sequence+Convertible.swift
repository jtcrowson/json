extension Sequence where Iterator.Element: JSONRepresentable {
    public func makeJSON() throws -> JSON {
        let json: [StructuredData] = try map {
            try $0.makeJSON().wrapped
        }
        return JSON(.array(json))
    }
    
    func makeJSONIncluding(keys: [String]) throws -> JSON {
        let json: [StructuredData] = try map {
            try $0.makeJSONIncluding(keys: keys).wrapped
        }
        return JSON(.array(json))
    }
    
    func makeJSONExcluding(keys: [String]) throws -> JSON {
        let json: [StructuredData] = try map {
            try $0.makeJSONExcluding(keys: keys).wrapped
        }
        return JSON(.array(json))
    }
}
