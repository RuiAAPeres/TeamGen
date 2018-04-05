import Foundation

public typealias Team = [Player]
public typealias Teams = (Team, Team)

public func generateTeams(_ allPlayers: [Player]) -> Teams {

    func intoTwoTeams(teams: Teams, player: Player) -> Teams {

        let lhsTeam = teams.0
        let rhsTeam = teams.1

        if totalScore(lhsTeam) > totalScore(rhsTeam) {
            return (lhsTeam, rhsTeam + [player])
        }
        else {
            return (lhsTeam + [player], rhsTeam)
        }
    }
    
    func generateTeams(_ allPlayers: [Player]) -> [Teams] {
        return (0...10000).map { _ in
            allPlayers.shuffled().reduce(([], []), intoTwoTeams)
        }
    }
    
    func balanceTeam(first: Teams, second: Teams) -> Bool {
        
        func differenceSkill(_ teams: Teams) -> Double {
            return abs(totalScore(teams.0) - totalScore(teams.1))
        }

        let firstBalance = differenceSkill(first)
        let secondBalance = differenceSkill(second)
        
        return firstBalance < secondBalance
    }

    return generateTeams(allPlayers).sorted(by: balanceTeam).first!
}

private func totalScore(_ team: Team) -> Double {
    func toScore(_ score: Double, player: Player) -> Double {
        return score + player.total
    }
    return team.reduce(0.0, toScore)
}

public func prettyPrint(_ teams: Teams) {
    let team1 = teams.0
    let team2 = teams.1

    func printPlayer(_ position: Int, _ player: Player) {
        print("\(position + 1). \(player.name) | \(player.total)")
    }

    func printTeam(_ teamName: String, _ team: Team) {
        print("------------       \(teamName)       ------------ ")
        team.enumerated().forEach(printPlayer)
        print("------------   Total score: \(team |> totalScore)   ------------ ")
    }

    printTeam("Team 1", team1)
    print("\n")
    printTeam("Team 2", team2)
}

// From here: https://gist.github.com/ijoshsmith/5e3c7d8c2099a3fe8dc3
extension Array {
    func shuffled() -> Array {
        var temp = self
        for _ in 0..<temp.count {
            temp.sort { (_,_) in arc4random() < arc4random() }
        }
        return temp
    }
}
