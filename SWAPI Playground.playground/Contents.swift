import UIKit

struct Person: Decodable {
    let name: String
    let height: String
    let films: [URL]
    let vehicles: [URL]
    
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

struct Vehicles: Decodable {
    let name: String
    let model: String
    let manufacturer: String
    let passengers: String
    let cost_in_credits: String
}



class SwapiService{
    
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping(Person?) -> Void){
        
        
        // Step 1: Construct URL
        guard let baseURL = baseURL else {return completion(nil)}
        let finalURL = baseURL.appendingPathComponent("people/\(id)/")
        
        print(finalURL)
        
        // Step 2: Data Task **ADD .RESUME() AT END OF FUNCTION**
        // Hit enter on second half
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            // Step 3: Handle Error
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion (nil)
                
            }
            
            if let response = response as? HTTPURLResponse{
                print("STATUS CODE: \(response.statusCode)")
            }
            
            // Step 4: Make sure we got data
            // aka unwrap it
            guard let data = data else { return completion(nil)}
            print(data)
            
            // Step 5: Decode data **.SELF ON THE TYPE OF DATA**
            //Try catch JSONDecoder().decode
            do{
                let person = try JSONDecoder().decode(Person.self, from: data)
                
                print("Doing")
                completion(person)
                return
                
            }catch{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
           
            
            
        }.resume()
        
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        print(url)
      // 2 - Contact server
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // 3 - Handle errors
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion (nil)
            }
            
            // 4 - Check for data
            guard let data = data else { return completion(nil)}
            
            // 5 - Decode Film from JSON
            do{
                let film = try JSONDecoder().decode(Film.self, from: data)
                print("Doing")
                completion(film)
                return
                
            }catch{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
                
            }
        }.resume()
    }
}


SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        
        for index in person.films{
            
            fetchFilm(index)
        }
    }
}

print("")

func fetchFilm(_ url: URL) {
  SwapiService.fetchFilm(url: url) { film in
      if let film = film {
          print(film)
      }
  }
}
