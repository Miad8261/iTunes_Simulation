        //
        //  StoreItem.swift
        //  Miad_iTunes_iOS2FinalProject
        //
        //  Created by mobileapps on 2019-02-15.
        //  Copyright © 2019 mobileapps. All rights reserved.
        //

        import Foundation

        var favoritesItems = [StoreItem]()
        var favoriteMovies = [StoreItem]()
        var favoriteMusic = [StoreItem]()
        var favoriteApps = [StoreItem]()
        var favoriteBooks = [StoreItem]()

        struct StoreItems: Codable, Equatable {
            let results: [StoreItem]
        }

        struct StoreItem: Codable {
            var name: String
            var artist: String
            var description: String
            var kind: String
            var artworkURL: URL
            
            enum CodingKeys: String, CodingKey {
                
                case name = "trackName"
                case artist = "artistName"
                case kind = "kind"
                case description = "description"
                case artworkURL = "artworkUrl100"
            }
            
            enum AdditionalKeys: String, CodingKey {
                case longDescription
            }
            
            init(name: String, artist: String, kind: String, description: String, artworkURL: URL) {
                self.name = name
                self.artist = artist
                self.kind = kind
                self.description = description
                self.artworkURL = artworkURL
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                
                // Mapping betwen instance variables and CodingKeys cases
                name = try values.decode(String.self, forKey: CodingKeys.name)
                artist = try values.decode(String.self, forKey: CodingKeys.artist)
                kind = try values.decode(String.self, forKey: CodingKeys.kind)
                artworkURL = try values.decode(URL.self, forKey: CodingKeys.artworkURL)
                
                if let description = try? values.decode(String.self, forKey: CodingKeys.description) {
                    // 1- If managed to extract some information from JSON by "description" key assign it to "description" instance variable as usual
                    self.description = description
                } else {
                    // 2- Otherwise consider an other key which is introduced in other enum "AdditionalKeys" for decoding
                    let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
                    
                    // 3- Map enum case "longDescription" which has the same key in JSON responce with instance variable "description"
                    description = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? ""
                }
            }
            
            static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            static let archiveURLMovies = documentDirectory.appendingPathComponent("Movies").appendingPathExtension("me")
            static let archiveURLMusic = documentDirectory.appendingPathComponent("Music").appendingPathExtension("me")
            static let archiveURLApps = documentDirectory.appendingPathComponent("Apps").appendingPathExtension("me")
            static let archiveURLBooks = documentDirectory.appendingPathComponent("Books").appendingPathExtension("me")
        }

        func save() {
            
            let propertyListEncoder = PropertyListEncoder()
            
            var encodedNoteArray = try? propertyListEncoder.encode(favoriteMovies)
            try? encodedNoteArray?.write(to: StoreItem.archiveURLMovies, options: .noFileProtection)
            
            encodedNoteArray = try? propertyListEncoder.encode(favoriteMusic)
            try? encodedNoteArray?.write(to: StoreItem.archiveURLMusic, options: .noFileProtection)
            
            encodedNoteArray = try? propertyListEncoder.encode(favoriteApps)
            try? encodedNoteArray?.write(to: StoreItem.archiveURLApps, options: .noFileProtection)
            
            encodedNoteArray = try? propertyListEncoder.encode(favoriteBooks)
            try? encodedNoteArray?.write(to: StoreItem.archiveURLBooks, options: .noFileProtection)
        }

        func loadFromFile() {
            
            let propertyListDecoder = PropertyListDecoder()
            if let retrievedNoteData = try? Data(contentsOf: StoreItem.archiveURLMovies), let decodedNotes = try?
                propertyListDecoder.decode(Array<StoreItem>.self, from: retrievedNoteData) {
                print(decodedNotes)
                favoriteMovies = decodedNotes
            }
            if let retrievedNoteData = try? Data(contentsOf: StoreItem.archiveURLMusic), let decodedNotes = try?
                propertyListDecoder.decode(Array<StoreItem>.self, from: retrievedNoteData) {
                print(decodedNotes)
                favoriteMusic = decodedNotes
            }
            if let retrievedNoteData = try? Data(contentsOf: StoreItem.archiveURLApps), let decodedNotes = try?
                propertyListDecoder.decode(Array<StoreItem>.self, from: retrievedNoteData) {
                print(decodedNotes)
                favoriteApps = decodedNotes
            }
            if let retrievedNoteData = try? Data(contentsOf: StoreItem.archiveURLBooks), let decodedNotes = try?
                propertyListDecoder.decode(Array<StoreItem>.self, from: retrievedNoteData) {
                print(decodedNotes)
                favoriteBooks = decodedNotes
            }
        }

        extension StoreItem: Equatable {
            static func == (lhs: StoreItem, rhs: StoreItem) -> Bool {
                return lhs.name == rhs.name
            }
        }
