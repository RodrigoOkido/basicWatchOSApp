//
//  ContentView.swift
//  basicWatchOSApp WatchKit Extension
//
//  Created by Rodrigo Yukio Okido on 30/03/22.
//

import SwiftUI


class Operands: ObservableObject {
    @Published var left_operand = -1
    @Published var right_operand = -1
    @Published var numbers = [1,2,3,4,5,6,7,8,9,0]
}

class CalcHistory: ObservableObject {
    @Published var calcHistory: [Int] = []
}


// MARK: - DUMMY CALCULATOR
struct DummyCalculator: View {
    
    @StateObject var operands = Operands()
    @StateObject var myHistory = CalcHistory()
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    Text("Sum: \(previewLeftOperand())+\(previewRightOperand())")
                    Divider()
                    CalculatorBody(operands: operands, myHistory: myHistory)

                }
            }
        }
    }
    
    //MARK: - PREVIEW SCREEN
    
    /**
     Preview left operand to calculate.
     */
    func previewLeftOperand() -> String {
        var leftOperandPreview = ""
        
        if operands.left_operand == -1 {
            leftOperandPreview = "_"
        } else {
            leftOperandPreview = "\(operands.left_operand)"
        }
        
        return leftOperandPreview
    }
    
    
    /**
     Preview right operand to calculate.
     */
    func previewRightOperand() -> String {
        var previewRightOperand = ""
        
        if operands.right_operand == -1 {
            previewRightOperand = "_"
        } else {
            previewRightOperand = "\(operands.right_operand)"
        }
        
        return previewRightOperand
    }
}


// MARK: - CALCULATOR BODY
/**
 Calculator Body. Display all numbers and actions buttons to user press.
 */
struct CalculatorBody: View {
    @ObservedObject var operands: Operands
    @ObservedObject var myHistory: CalcHistory
    

    var body: some View {
        VStack {
            HStack {
                Button("1") {
                    setOperandValue(value: 1)
                }
                Button("2") {
                    setOperandValue(value: 2)
                }
                Button("3") {
                    setOperandValue(value: 3)
                }
            }
            HStack {
                Button("4") {
                    setOperandValue(value: 4)
                }
                Button("5") {
                    setOperandValue(value: 5)
                }
                Button("6") {
                    setOperandValue(value: 6)
                }
            }
            HStack {
                Button("7") {
                    setOperandValue(value: 7)
                }
                Button("8") {
                    setOperandValue(value: 8)
                }
                Button("9") {
                    setOperandValue(value: 9)
                }
            }
            HStack{
                Button("C") {
                    operands.left_operand = -1
                    operands.right_operand = -1
                }
                .background(.red)
                .cornerRadius(10)
                Button("0") {
                    setOperandValue(value: 0)
                }
                NavigationLink(destination: ResultScene(operands: operands, myHistory: myHistory).onAppear {
                    self.addResultToHistory()
                })  {
                    Text("=")
                }
                .background(.blue)
                .cornerRadius(10)
            }

        }
    }
    

    /**
     Add result to user history.
     */
    func addResultToHistory() {
        if operands.left_operand != -1 && operands.right_operand != -1 {
            myHistory.calcHistory.append(operands.left_operand+operands.right_operand)
        }
    }
    
    
    /**
     Set operand values.
     */
    func setOperandValue(value: Int) {
        if operands.left_operand == -1 {
            operands.left_operand = value
        } else {
            operands.right_operand = value
        }
    }
}


// MARK: - RESULT SCENE
/**
 Result Scene view. Displays the result after users input the numbers.
 */
struct ResultScene: View {
    @ObservedObject var operands: Operands
    @ObservedObject var myHistory: CalcHistory
    @State private var showingAlert = false

    
    var body: some View {
        VStack {
            Circle()
                .strokeBorder(Color.blue, lineWidth: 2, antialiased: true)
                .overlay {
                    if operands.left_operand == -1 || operands.right_operand == -1 {
                        Text("0")
                    } else {
                        Text("\(operands.left_operand + operands.right_operand)")
                    }
                }
            Divider()
            ScrollView {
                ForEach(myHistory.calcHistory, id: \.self) { result in
                    HStack {
                        Image(systemName: "chevron.right")
                        Text("\(result)")
                    }
                }
                Button("Clear") {
                    self.showingAlert = true
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(""), message: Text("History cleared!"), dismissButton: .default(Text("Ok"), action: {
                        myHistory.calcHistory.removeAll()
                        operands.left_operand = -1
                        operands.right_operand = -1
                    }))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DummyCalculator()
    }
}
