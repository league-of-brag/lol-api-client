import Vapor

public class LOLAPIClient {
    let riotAPIToken: String
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()
    
    init(riotAPIToken: String) {
        self.riotAPIToken = riotAPIToken
    }
    
    /// See: https://developer.riotgames.com/apis#summoner-v4/GET_getBySummonerName
    public func fetchSummoner(serverRegion: ServerRegion,
                              summonerName: String,
                              request: Request) async throws -> SummonerDTO {
        let baseURL = Self.baseURL(for: serverRegion)
        let requestURI: URI = "\(baseURL)/lol/summoner/v4/summoners/by-name/\(summonerName)"
        let response = try await request.client.get(requestURI) { req in
            req.headers.add(name: "X-Riot-Token", value: riotAPIToken)
            req.headers.add(name: "Accept-Language", value: "en-US,en;q=0.7")
            req.headers.replaceOrAdd(name: "Accept", value: "application/json;charset=utf-8")
            req.headers.replaceOrAdd(name: "Content-Type", value: "application/json;charset=utf-8")
        }
        guard response.status.isValid() else {
            throw Abort(response.status)
        }
        let json = try response.content.decode(SummonerDTO.self, using: decoder)
        return json
    }
    
    /// See: https://developer.riotgames.com/apis#champion-mastery-v4/GET_getAllChampionMasteriesByPUUID
    public func fetchChampionMasteries(serverRegion: ServerRegion,
                                       puuid: String,
                                       request: Request) async throws -> [ChampionMasteryDTO] {
        let baseURL = Self.baseURL(for: serverRegion)
        let requestURI: URI = "\(baseURL)/lol/champion-mastery/v4/champion-masteries/by-puuid/\(puuid)"
        let response = try await request.client.get(requestURI) { req in
            req.headers.add(name: "X-Riot-Token", value: riotAPIToken)
            req.headers.add(name: "Accept-Language", value: "en-US,en;q=0.7")
            req.headers.replaceOrAdd(name: "Accept", value: "application/json;charset=utf-8")
            req.headers.replaceOrAdd(name: "Content-Type", value: "application/json;charset=utf-8")
        }
        guard response.status.isValid() else {
            throw Abort(response.status)
        }
        let json = try response.content.decode([ChampionMasteryDTO].self, using: decoder)
        return json
    }
    
    /// See: https://developer.riotgames.com/apis#champion-mastery-v4/GET_getChampionMasteryByPUUID
    public func fetchChampionMastery(serverRegion: ServerRegion,
                                     puuid: String,
                                     championId: ChampionID,
                                     request: Request) async throws -> ChampionMasteryDTO {
        let baseURL = Self.baseURL(for: serverRegion)
        let requestURI: URI = "\(baseURL)/lol/champion-mastery/v4/champion-masteries/by-puuid/\(puuid)/by-champion/\(championId)"
        let response = try await request.client.get(requestURI) { req in
            req.headers.add(name: "X-Riot-Token", value: riotAPIToken)
            req.headers.add(name: "Accept-Language", value: "en-US,en;q=0.7")
            req.headers.replaceOrAdd(name: "Accept", value: "application/json;charset=utf-8")
            req.headers.replaceOrAdd(name: "Content-Type", value: "application/json;charset=utf-8")
        }
        guard response.status.isValid() else {
            throw Abort(response.status)
        }
        let json = try response.content.decode(ChampionMasteryDTO.self, using: decoder)
        return json
    }
    
    public func fetchChampions(request: Request) async throws -> ChampionsResponse {
        let requestURI: URI = "https://ddragon.leagueoflegends.com/cdn/13.24.1/data/en_US/champion.json"
        let response = try await request.client.get(requestURI)
        guard response.status.isValid() else {
            throw Abort(response.status)
        }
        let json = try response.content.decode(ChampionsResponse.self)
        return json
    }
    
    // MARK: Helper methods
    
    private static func baseURL(for serverRegion: ServerRegion) -> String {
        return "https://\(serverRegion.rawValue.lowercased()).api.riotgames.com"
    }
}
