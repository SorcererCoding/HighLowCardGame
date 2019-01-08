//
//  GameViewController.swift
//  High Low Cards
//
//  Created by Robert Huber on 12/19/18.
//  Copyright © 2018 SorcererCoding. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    
    @IBOutlet weak var playerLabel: UILabel!
    
    
    @IBOutlet weak var cardOneImageView: UIImageView!
    @IBOutlet weak var cardTwoImageView: UIImageView!
    @IBOutlet weak var cardThreeImageView: UIImageView!
    @IBOutlet weak var cardFourImageView: UIImageView!
    @IBOutlet weak var cardFiveImageView: UIImageView!
    @IBOutlet weak var cardSixImageView: UIImageView!
    @IBOutlet weak var cardSevenImageView: UIImageView!

    
    @IBOutlet weak var scoreBoardLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    
    var isCurrentPlayerOne = true
    var previousCard = 0
    var currentCard = 0
    var previousCardValue = 0
    var currentCardValue = 0
    var currentEmptySlot = 2
    var startingEmptySlot = 2
    
    var otherPlayerCurrentCard = 0
    var otherPlayerCurrentCardValue = 0
    var otherPlayerEmptySlot = 2
    
    var otherPlayerBoard : [Int] = []
    var currentPlayerBoard : [Int] = []
    
    @IBAction func holdPressed(_ sender: Any) {
        
        
        currentCard = Int(randomCard())
        currentCardValue = Int(floor(Double(currentCard/4)))
        currentPlayerBoard.removeLast()
        currentPlayerBoard.append(currentCard)
        switchPlayer()
        
    }
    //This function switchs the players when the turn changes
    func switchPlayer (){
        
        swapGameState(isPlayerOne: isCurrentPlayerOne)
        
        isCurrentPlayerOne = !isCurrentPlayerOne
        
        if isCurrentPlayerOne {
            playerLabel.text = "Player 1"
        } else {
            playerLabel.text = "Player 2"
        }
        
        
        var cardBack = ""
        
        if isCurrentPlayerOne {
            cardBack = "blueBack"
        } else {
            cardBack = "redBack"
        }
        
        for slot in currentEmptySlot...7 {
            
            switch slot {
            case 2:
                cardTwoImageView.image = UIImage(named: cardBack)
            case 3:
                cardThreeImageView.image = UIImage(named: cardBack)
            case 4:
                cardFourImageView.image = UIImage(named: cardBack)
            case 5:
                cardFiveImageView.image = UIImage(named: cardBack)
            case 6:
                cardSixImageView.image = UIImage(named: cardBack)
            case 7:
                cardSevenImageView.image = UIImage(named: cardBack)
                
            default:
               createAlert(title: "Errror", message: "something went wrong")
            }
        }
        
    }
    
    @IBAction func higherPressed(_ sender: Any) {
        let cardNumber = randomCard()
        currentPlayerBoard.append(Int(cardNumber))
       
        previousCard = currentCard
        
        currentCard = Int(cardNumber)
        
        
        previousCardValue = currentCardValue
        currentCardValue = Int(floor(Double(cardNumber/4)))
        
        var drawnCard = UIImage()
        
        if isCurrentPlayerOne{
            drawnCard = drawACard(deck: deckPlayerOne, index: Int(cardNumber))
        } else {
            drawnCard = drawACard(deck: deckPlayerTwo, index: Int(cardNumber))
        }
        
        switch currentEmptySlot {
            
        case 2:
            cardTwoImageView.image = drawnCard
        case 3:
            cardThreeImageView.image = drawnCard
        case 4:
            cardFourImageView.image = drawnCard
        case 5:
            cardFiveImageView.image = drawnCard
        case 6:
            cardSixImageView.image = drawnCard
        case 7:
            cardSevenImageView.image = drawnCard
        default:
            createAlert(title: "Error", message: "No Card Number")
            
        }
        
        currentEmptySlot += 1
        
        if currentCardValue > previousCardValue {
           
            if currentEmptySlot == 8 {
                endGame()
            }
            
        } else {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                self.resetCards()
            }
        }
        
    }
    
    
    @IBOutlet weak var holdButton: UIButton!
    @IBOutlet weak var higherButton: UIButton!
    @IBOutlet weak var lowerButton: UIButton!
    
    
    @IBAction func resetScores(_ sender: Any) {
        UserDefaults.standard.set(0, forKey: "Player 1 Score")
        UserDefaults.standard.set(0, forKey: "Player 2 Score")
        
        setupGame()
        
    }
    @IBAction func lowerPressed(_ sender: Any) {
        let cardNumber = randomCard()
        currentPlayerBoard.append(Int(cardNumber))
        
        previousCard = currentCard
        
        currentCard = Int(cardNumber)
        
        
        previousCardValue = currentCardValue
        currentCardValue = Int(floor(Double(cardNumber/4)))
        
        var drawnCard = UIImage()
        
        if isCurrentPlayerOne{
            drawnCard = drawACard(deck: deckPlayerOne, index: Int(cardNumber))
        } else {
            drawnCard = drawACard(deck: deckPlayerTwo, index: Int(cardNumber))
        }
        
        switch currentEmptySlot {
            
        case 2:
            cardTwoImageView.image = drawnCard
        case 3:
            cardThreeImageView.image = drawnCard
        case 4:
            cardFourImageView.image = drawnCard
        case 5:
            cardFiveImageView.image = drawnCard
        case 6:
            cardSixImageView.image = drawnCard
        case 7:
            cardSevenImageView.image = drawnCard
        default:
           createAlert(title: "Error", message: "No Card Number")
        }
        
        currentEmptySlot += 1
        
        if currentCardValue < previousCardValue {
            
            if currentEmptySlot == 8 {
                endGame()
            }
            
        } else {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                self.resetCards()
            }
        }
        
        
    }
    
    
    func randomCard () -> UInt32  {
        let cardNumber = arc4random_uniform(50) + 2
        
        if currentPlayerBoard.count > 0{
            for card in 0...currentPlayerBoard.count - 1 {
                
                if cardNumber == currentPlayerBoard[card] {
                    return randomCard()
                }
                
            }
        }
        if cardNumber == currentCard {
            return randomCard ()
        }
        
        return cardNumber
    }
    
    
    @IBAction func newGame(_ sender: Any) {
        winLabel.isHidden = true
        
        setupGame()
    }
    
    var deckPlayerOne : [UIImage] = []
    var deckPlayerTwo : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGame()
        
    }
    
    func setupGame() {
        currentPlayerBoard.removeAll()
        otherPlayerBoard.removeAll()
        
        isCurrentPlayerOne = true
        previousCard = 0
        currentCard = 0
        previousCardValue = 0
        currentCardValue = 0
        currentEmptySlot = 2
        startingEmptySlot = 2
        
        otherPlayerCurrentCard = 0
        otherPlayerCurrentCardValue = 0
        otherPlayerEmptySlot = 2
        
        
        higherButton.isEnabled = true
        lowerButton.isEnabled = true
        holdButton.isEnabled = true
        
        //Build Decks
        if deckPlayerOne.count == 0 {
            for cardNumber in 2...14 {
                
                deckPlayerOne.append(UIImage(named: "\(cardNumber)_of_clubs")!)
                deckPlayerOne.append(UIImage(named: "\(cardNumber)_of_diamonds")!)
                deckPlayerOne.append(UIImage(named: "\(cardNumber)_of_hearts")!)
                deckPlayerOne.append(UIImage(named: "\(cardNumber)_of_spades")!)
                deckPlayerTwo.append(UIImage(named: "\(cardNumber)_of_clubs")!)
                deckPlayerTwo.append(UIImage(named: "\(cardNumber)_of_diamonds")!)
                deckPlayerTwo.append(UIImage(named: "\(cardNumber)_of_hearts")!)
                deckPlayerTwo.append(UIImage(named: "\(cardNumber)_of_spades")!)
            }
        }
        
        let firstCard = Int(randomCard())
        
        let otherPlayerFirstCard = Int(randomCard())
        
        otherPlayerBoard.append(otherPlayerFirstCard)
        currentPlayerBoard.append(firstCard)
        
        otherPlayerCurrentCard = otherPlayerFirstCard
        otherPlayerCurrentCardValue = Int(floor(Double(otherPlayerFirstCard/4)))
        
        currentCard = firstCard
        currentCardValue = Int(floor(Double(firstCard/4)))
        
        cardOneImageView.image = drawACard(deck: deckPlayerOne, index: firstCard)
        
        cardThreeImageView.image = UIImage(named: "blueBack")
        cardFourImageView.image = UIImage(named: "blueBack")
        cardFiveImageView.image = UIImage(named: "blueBack")
        cardSixImageView.image = UIImage(named: "blueBack")
        cardSevenImageView.image = UIImage(named: "blueBack")
        cardTwoImageView.image = UIImage(named: "blueBack")
        
        let playerOneScore = UserDefaults.standard.integer(forKey: "Player 1 Score")
        let playerTwoScore = UserDefaults.standard.integer(forKey: "Player 2 Score")
        scoreBoardLabel.text = "Scoreboard Player 1: \(playerOneScore)  Player 2: \(playerTwoScore)"
        
        currentEmptySlot = 2
    }
    
    func drawACard (deck: [UIImage], index: Int) -> UIImage {
        
        let drawnCard = deck[index]
        
        return drawnCard
    }
    
    
    func swapGameState (isPlayerOne: Bool) {
        
        //swaps the current card
        let swapCard = currentCard
        currentCard = otherPlayerCurrentCard
        otherPlayerCurrentCard = swapCard
        
        //swaps the current card value
        let swapCardValue = currentCardValue
        currentCardValue = otherPlayerCurrentCardValue
        otherPlayerCurrentCardValue = swapCardValue
        
        //swaps the last card locked in for player
        let swapSlot = currentEmptySlot
        currentEmptySlot = otherPlayerEmptySlot
        startingEmptySlot = otherPlayerEmptySlot
        otherPlayerEmptySlot = swapSlot
        
        //swaps the current play board
        let swapBoard = currentPlayerBoard
        currentPlayerBoard = otherPlayerBoard
        otherPlayerBoard = swapBoard
        
        for cardImage in 0...currentPlayerBoard.count - 1 {
            
            switch cardImage {
                
            case 0:
                cardOneImageView.image = deckPlayerOne[currentPlayerBoard[cardImage]]
                
            case 1:
                cardTwoImageView.image = deckPlayerOne[currentPlayerBoard[cardImage]]
                
            case 2:
                cardThreeImageView.image = deckPlayerOne[currentPlayerBoard[cardImage]]
                
            case 3:
                cardFourImageView.image = deckPlayerOne[currentPlayerBoard[cardImage]]
                
            case 4:
                cardFiveImageView.image = deckPlayerOne[currentPlayerBoard[cardImage]]
                
            case 5:
                cardSixImageView.image = deckPlayerOne[currentPlayerBoard[cardImage]]
                
            case 6:
                cardSevenImageView.image = deckPlayerOne[currentPlayerBoard[cardImage]]
                
            default:
                createAlert(title: "Errror", message: "something went wrong")
                
            }
            
        }
        
        
        
    }
    
    func endGame() {
        
        higherButton.isEnabled = false
        lowerButton.isEnabled = false
        holdButton.isEnabled = false
        
        if isCurrentPlayerOne {
            winLabel.isHidden = false
            winLabel.text = "Player 1 Wins!"
            winLabel.textColor = UIColor.blue
            let playerOneScore = UserDefaults.standard.integer(forKey: "Player 1 Score") + 1

            UserDefaults.standard.set(playerOneScore, forKey: "Player 1 Score")
            
            
        } else {
            winLabel.isHidden = false
            winLabel.text = "Player 2 Wins!"
            winLabel.textColor = UIColor.red
            let playerTwoScore = UserDefaults.standard.integer(forKey: "Player 2 Score") + 1
            
            UserDefaults.standard.set(playerTwoScore, forKey: "Player 2 Score")
        }
        if let winner = winLabel.text {
            createAlert(title: "Game Over", message: winner)
        }
        
    }
    
    func resetCards() {
 
        currentCard = currentPlayerBoard[startingEmptySlot - 2]
        currentCardValue = Int(floor(Double(currentCard/4)))
        var resetBoard : [Int] = []
        
        for slot in 0...startingEmptySlot - 2 {
            
            resetBoard.append(currentPlayerBoard[slot])
            
        }
        currentPlayerBoard = resetBoard
    
        currentEmptySlot = startingEmptySlot
        switchPlayer()
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
}

