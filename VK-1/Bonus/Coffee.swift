//
//  Coffee.swift
//  VK-1
//
//  Created by Юрий Егоров on 26.04.2021.
//

import UIKit

protocol Coffee {
    var cost: Int { get }
}
protocol CoffeeDecorator: Coffee {
    var base: Coffee { get }
    init(base: Coffee)
}
class SimpleCoffee: Coffee {
    var cost: Int {
        return 60
    }
}
class Milk: CoffeeDecorator {
    var cost: Int {
        return base.cost + 40
    }
    
    let base: Coffee
    
    required init(base: Coffee) {
        self.base = base
    }
}
class Whip: CoffeeDecorator {
    var cost: Int {
        return base.cost + 20
    }
    
    let base: Coffee
    
    required init(base: Coffee) {
        self.base = base
    }
}
class Sugar: CoffeeDecorator {
    var cost: Int {
        return base.cost + 30
    }
    
    let base: Coffee
    
    required init(base: Coffee) {
        self.base = base
    }
}
//let tea = SimpleCoffee()
//let withMilk = Milk(base: tea)
//let withMilkAndSuger = Sugar(base: withMilk)
//let withDoubleSugarAndMilk = Sugar(base: withMilkAndSuger)
//print(tea.cost, withMilk.cost, withMilkAndSuger.cost, withDoubleSugarAndMilk.cost)





