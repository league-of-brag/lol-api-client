import Vapor

public class LOLAPIClient {
    /// See: https://developer.riotgames.com/apis#summoner-v4/GET_getBySummonerName
    public static func fetchSummoner(serverRegion: ServerRegion,
                                     summonerName: String,
                                     request: Request) async throws -> SummonerDTO {
        guard let riotToken = Environment.get("X-Riot-Token") else {
            throw Abort(.internalServerError)
        }
        let baseURL = baseURL(for: serverRegion)
        let requestURI: URI = "\(baseURL)/lol/summoner/v4/summoners/by-name/\(summonerName)"
        let response = try await request.client.get(requestURI) { req in
            req.headers.add(name: "X-Riot-Token", value: riotToken)
            req.headers.add(name: "Accept-Language", value: "en-US,en;q=0.7")
            req.headers.replaceOrAdd(name: "Accept", value: "application/json;charset=utf-8")
            req.headers.replaceOrAdd(name: "Content-Type", value: "application/json;charset=utf-8")
        }
        guard response.status.isValid() else {
            throw Abort(response.status)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        let json = try response.content.decode(SummonerDTO.self, using: decoder)
        return json
    }
    
    /// See: https://developer.riotgames.com/apis#champion-mastery-v4/GET_getAllChampionMasteriesByPUUID
    public static func fetchChampionMasteries(serverRegion: ServerRegion,
                                              puuid: String,
                                              request: Request) async throws -> [ChampionMasteryDTO] {
        guard let riotToken = Environment.get("X-Riot-Token") else {
            throw Abort(.internalServerError)
        }
        let baseURL = baseURL(for: serverRegion)
        let requestURI: URI = "\(baseURL)/lol/champion-mastery/v4/champion-masteries/by-puuid/\(puuid)"
        let response = try await request.client.get(requestURI) { req in
            req.headers.add(name: "X-Riot-Token", value: riotToken)
            req.headers.add(name: "Accept-Language", value: "en-US,en;q=0.7")
            req.headers.replaceOrAdd(name: "Accept", value: "application/json;charset=utf-8")
            req.headers.replaceOrAdd(name: "Content-Type", value: "application/json;charset=utf-8")
        }
        guard response.status.isValid() else {
            throw Abort(response.status)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        let json = try response.content.decode([ChampionMasteryDTO].self, using: decoder)
        return json
    }
    
    /// See: https://developer.riotgames.com/apis#champion-mastery-v4/GET_getChampionMasteryByPUUID
    public static func fetchChampionMastery(serverRegion: ServerRegion,
                                            puuid: String,
                                            championId: ChampionID,
                                            request: Request) async throws -> ChampionMasteryDTO {
        guard let riotToken = Environment.get("X-Riot-Token") else {
            throw Abort(.internalServerError)
        }
        let baseURL = baseURL(for: serverRegion)
        let requestURI: URI = "\(baseURL)/lol/champion-mastery/v4/champion-masteries/by-puuid/\(puuid)/by-champion/\(championId)"
        let response = try await request.client.get(requestURI) { req in
            req.headers.add(name: "X-Riot-Token", value: riotToken)
            req.headers.add(name: "Accept-Language", value: "en-US,en;q=0.7")
            req.headers.replaceOrAdd(name: "Accept", value: "application/json;charset=utf-8")
            req.headers.replaceOrAdd(name: "Content-Type", value: "application/json;charset=utf-8")
        }
        guard response.status.isValid() else {
            throw Abort(response.status)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        let json = try response.content.decode(ChampionMasteryDTO.self, using: decoder)
        return json
    }
    
    public static func fetchChampions(request: Request) async throws -> ChampionsResponse {
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
