//
//  ViewController.swift
//  Lab2_SimranjitSingh_C0809865_iOS
//
//  Created by user213023 on 1/25/22.
//

import UIKit

class ViewController: UIViewController {

    //Labels for turn, result and scoreboard
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scoreLabelX: UILabel!
    @IBOutlet weak var scoreLabelO: UILabel!
    
    //Outlets for all buttons on the board
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    //Players
    enum Turn {
            case Cross
            case Circle
        }
    
    //Variables to track turns
    var firstTurn = Turn.Cross
    var currentTurn = Turn.Cross
    
    //Variables to store actual letters/Icons
    var CROSS = "X"
    var CIRCLE = "O"
    
    //Scores
    var crossScore = 0
    var circleScore = 0
    
    //Game State
    var state = "ongoing"
    
    //Array of buttons
    var board = [UIButton]()
    
    //Variable to check if there's no winner
    var noWinner = false
    
    //Variable to track the last move
    var lastMove = ""
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    //Function for shake detection
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initBoard()
        
        //Swipe gesture to reset the game
        let swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(resetGame(_:)))
        view.addGestureRecognizer(swipeRec)
        
    }

    //Function to reset the game after swiping
    @objc func resetGame(_ sender: UISwipeGestureRecognizer) {
        resultLabel.text = ""
        state = "ongoing"
        for button in board
        {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
    }
    
    //Function to fill the array with buttons
    func initBoard(){
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }
    
    //Checking the board for the tap recognition
    @IBAction func tapCheckerAction(_ sender: UIButton) {
        filllTheBoard(sender)
        if state == "over"{
            return
        }
        else{
                if winnerChecker(CROSS)
                {
                    crossScore += 1
                    resultLabel.text = "Cross Won!"
                    scoreLabelX.text = "\(crossScore)"
                    state = "over"
                    noWinner = false
                }
                
                if winnerChecker(CIRCLE)
                {
                    circleScore += 1
                    resultLabel.text = "Circle Won!"
                    scoreLabelO.text = "\(circleScore)"
                    state = "over"
                    noWinner = false
                }
                
                //Draw if the board is full and there's no winner
                if(fullBoard() && noWinner)
                {
                    resultLabel.text = "Draw"
                    state = "over"
                }
        }
    }
    
    //Function to check all possible winning patterns
    func winnerChecker(_ s :String) -> Bool
        {
            //Horizontal
            if symbolCheck(a1, s) && symbolCheck(a2, s) && symbolCheck(a3, s)
            {
                return true
            }
            if symbolCheck(b1, s) && symbolCheck(b2, s) && symbolCheck(b3, s)
            {
                return true
            }
            if symbolCheck(c1, s) && symbolCheck(c2, s) && symbolCheck(c3, s)
            {
                return true
            }
            
            // Vertical
            if symbolCheck(a1, s) && symbolCheck(b1, s) && symbolCheck(c1, s)
            {
                return true
            }
            if symbolCheck(a2, s) && symbolCheck(b2, s) && symbolCheck(c2, s)
            {
                return true
            }
            if symbolCheck(a3, s) && symbolCheck(b3, s) && symbolCheck(c3, s)
            {
                return true
            }
            
            // Diagonal
            if symbolCheck(a1, s) && symbolCheck(b2, s) && symbolCheck(c3, s)
            {
                return true
            }
            if symbolCheck(a3, s) && symbolCheck(b2, s) && symbolCheck(c1, s)
            {
                return true
            }
            
            //There's no winner if none of the winning patterns are matched
            noWinner = true;
            return false
            
        }
    
    
    func symbolCheck(_ button: UIButton, _ symbol: String) -> Bool
        {
            return button.title(for: .normal) == symbol
        }
 
    //Function to check if the board is full or not
    func fullBoard() -> Bool
        {
            for button in board
            {
                if button.title(for: .normal) == nil
                {
                    return false
                }
            }
            return true
        }
    
    
    
    //Function to fill the board according to the current turn
    func filllTheBoard(_ sender: UIButton){
        
        if(state == "over"){
            return;
        } else{
        
        if(sender.title(for: .normal) == nil)
                {
                    if(currentTurn == Turn.Circle)
                    {
                        sender.setTitle(CIRCLE, for: .normal)
                        currentTurn = Turn.Cross
                        turnLabel.text = CROSS
                    }
                    else if(currentTurn == Turn.Cross)
                    {
                        sender.setTitle(CROSS, for: .normal)
                        currentTurn = Turn.Circle
                        turnLabel.text = CIRCLE
                    }
                    sender.isEnabled = false
                }
        }
    }
    
    
}

