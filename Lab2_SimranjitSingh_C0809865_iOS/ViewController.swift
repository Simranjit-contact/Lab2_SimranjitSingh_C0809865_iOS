//
//  ViewController.swift
//  Lab2_SimranjitSingh_C0809865_iOS
//
//  Created by user213023 on 1/25/22.
//

import Foundation
import UIKit
import CoreData

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
    var lastMove = 0
    
    //UserDefaults Instance
    var saveDefaults  = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initBoard()
        
        //Swipe gesture to reset the game
        let swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(resetGame(_:)))
        view.addGestureRecognizer(swipeRec)
        
        savedProfile()
        
        
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
        lastMove = sender.tag
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
        savingProfile()
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
    
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    //Function to undo the last move by shake detection
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if(state == "over"){
                return
            } else{
                if(lastMove == 1){
                    if(a1.title(for: .normal) == "O"){
                        currentTurn = Turn.Circle
                        turnLabel.text = CIRCLE
                    }
                    if(a1.title(for: .normal) == "X"){
                        currentTurn = Turn.Cross
                        turnLabel.text = CROSS
                    }
                    a1.setTitle(nil, for: .normal)
                    a1.isEnabled = true
                }
                if(lastMove == 2){
                    if(a2.title(for: .normal) == "O"){
                        currentTurn = Turn.Circle
                        turnLabel.text = CIRCLE
                    }
                    if(a2.title(for: .normal) == "X"){
                        currentTurn = Turn.Cross
                        turnLabel.text = CROSS
                    }
                    a2.setTitle(nil, for: .normal)
                    a2.isEnabled = true
                }
                if(lastMove == 3){
                    if(a3.title(for: .normal) == "O"){
                        currentTurn = Turn.Circle
                        turnLabel.text = CIRCLE
                    }
                    if(a3.title(for: .normal) == "X"){
                        currentTurn = Turn.Cross
                        turnLabel.text = CROSS
                    }
                    a3.setTitle(nil, for: .normal)
                    a3.isEnabled = true
                }
                if(lastMove == 4){
                    if(b1.title(for: .normal) == "O"){
                        currentTurn = Turn.Circle
                        turnLabel.text = CIRCLE
                    }
                    if(b1.title(for: .normal) == "X"){
                        currentTurn = Turn.Cross
                        turnLabel.text = CROSS
                    }
                    b1.setTitle(nil, for: .normal)
                    b1.isEnabled = true
                }
                if(lastMove == 5){
                    if(b2.title(for: .normal) == "O"){
                        currentTurn = Turn.Circle
                        turnLabel.text = CIRCLE
                    }
                    if(b2.title(for: .normal) == "X"){
                        currentTurn = Turn.Cross
                        turnLabel.text = CROSS
                    }
                    b2.setTitle(nil, for: .normal)
                    b2.isEnabled = true
                }
                if(lastMove == 6){
                    if(b3.title(for: .normal) == "O"){
                        currentTurn = Turn.Circle
                        turnLabel.text = CIRCLE
                    }
                    if(b3.title(for: .normal) == "X"){
                        currentTurn = Turn.Cross
                        turnLabel.text = CROSS
                    }
                    b3.setTitle(nil, for: .normal)
                    b3.isEnabled = true
                }
                if(lastMove == 7){
                    if(c1.title(for: .normal) == "O"){
                        currentTurn = Turn.Circle
                        turnLabel.text = CIRCLE
                    }
                    if(c1.title(for: .normal) == "X"){
                        currentTurn = Turn.Cross
                        turnLabel.text = CROSS
                    }
                    c1.setTitle(nil, for: .normal)
                    c1.isEnabled = true
                }
                if(lastMove == 8){
                    if(c2.title(for: .normal) == "O"){
                        currentTurn = Turn.Circle
                        turnLabel.text = CIRCLE
                    }
                    if(c2.title(for: .normal) == "X"){
                        currentTurn = Turn.Cross
                        turnLabel.text = CROSS
                    }
                    c2.setTitle(nil, for: .normal)
                    c2.isEnabled = true
                }
                if(lastMove == 9){
                    if(c3.title(for: .normal) == "O"){
                        currentTurn = Turn.Circle
                        turnLabel.text = CIRCLE
                    }
                    if(c3.title(for: .normal) == "X"){
                        currentTurn = Turn.Cross
                        turnLabel.text = CROSS
                    }
                    c3.setTitle(nil, for: .normal)
                    c3.isEnabled = true
                }
            }
            }
            
    }
    
    func savingProfile(){
        saveDefaults.setValue(a1.title(for: .normal), forKey: "a1")
        saveDefaults.setValue(a2.title(for: .normal), forKey: "a2")
        saveDefaults.setValue(a3.title(for: .normal), forKey: "a3")
        saveDefaults.setValue(b1.title(for: .normal), forKey: "b1")
        saveDefaults.setValue(b2.title(for: .normal), forKey: "b2")
        saveDefaults.setValue(b3.title(for: .normal), forKey: "b3")
        saveDefaults.setValue(c1.title(for: .normal), forKey: "c1")
        saveDefaults.setValue(c2.title(for: .normal), forKey: "c2")
        saveDefaults.setValue(c3.title(for: .normal), forKey: "c3")
        saveDefaults.setValue(scoreLabelX.text, forKey: "scorex")
        saveDefaults.setValue(scoreLabelO.text, forKey: "scoreo")
        saveDefaults.setValue(turnLabel.text, forKey: "current_turn")
        saveDefaults.setValue(resultLabel.text, forKey: "result")
    }

    func savedProfile(){
        if let value = saveDefaults.value(forKey: "a1") as? String{
            a1.setTitle(value, for: .normal)
        }
        if let value = saveDefaults.value(forKey: "a2") as? String{
            a2.setTitle(value, for: .normal)
        }
        if let value = saveDefaults.value(forKey: "a3") as? String{
            a3.setTitle(value, for: .normal)
        }
        if let value = saveDefaults.value(forKey: "b1") as? String{
            b1.setTitle(value, for: .normal)
        }
        if let value = saveDefaults.value(forKey: "b2") as? String{
            b2.setTitle(value, for: .normal)
        }
        if let value = saveDefaults.value(forKey: "b3") as? String{
            b3.setTitle(value, for: .normal)
        }
        if let value = saveDefaults.value(forKey: "c1") as? String{
            c1.setTitle(value, for: .normal)
        }
        if let value = saveDefaults.value(forKey: "c2") as? String{
            c2.setTitle(value, for: .normal)
        }
        if let value = saveDefaults.value(forKey: "c3") as? String{
            c3.setTitle(value, for: .normal)
        }
        if let value = saveDefaults.value(forKey: "scorex") as? String{
            scoreLabelX.text = value
        }
        if let value = saveDefaults.value(forKey: "scoreo") as? String{
            scoreLabelO.text = value
        }
        if let value = saveDefaults.value(forKey: "current_turn") as? String{
            turnLabel.text = value
        }
        if let value = saveDefaults.value(forKey: "result") as? String{
            resultLabel.text = value
        }
    }
    
}
