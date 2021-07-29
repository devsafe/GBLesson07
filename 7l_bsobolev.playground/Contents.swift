import UIKit
//1. Придумать класс, методы которого могут завершаться неудачей и возвращать либо значение, либо ошибку Error?. Реализовать их вызов и обработать результат метода при помощи конструкции if let, или guard let.
//
//2. Придумать класс, методы которого могут выбрасывать ошибки. Реализуйте несколько throws-функций. Вызовите их и обработайте результат вызова при помощи конструкции try/catch.


import UIKit

enum carError: Error{
    case engineBroken
    case lowOilLevel
    case lowFuelLevel (fuelNeed: Int)
    case noAvailableCar
    case noSuchCarInShop
}

struct car{
    var electricEngine: Bool
    var oil: Int
    var fuel: Int
    var battery: Int
    var stock: Int
}

class carShop {
    var showRoom = [
        "BMW": car(electricEngine: false, oil: 11, fuel: 90, battery: 100, stock: 2),
        "Mercedes": car(electricEngine: false, oil: 10, fuel: 99, battery: 100, stock: 3),
        "Renault": car(electricEngine: false, oil: 9, fuel: 65, battery: 90, stock: 2),
        "Tesla": car(electricEngine: true, oil: 0, fuel: 0, battery: 300, stock: 1),
        "McLaren": car(electricEngine: false, oil: 15, fuel: 100, battery: 100, stock: 1)
    ]
    var carFuelForTestDrive = 0
    
    func errors(carName name: String) throws {
        
        guard let cars = showRoom[name] else {
            throw carError.noAvailableCar
        }
        guard cars.stock > 0 else {
            throw carError.noAvailableCar
        }
        guard cars.fuel <= carFuelForTestDrive else {
            throw carError.lowFuelLevel(fuelNeed: cars.fuel - carFuelForTestDrive)
        }
        
        carFuelForTestDrive -= cars.fuel
        
        var someCars = cars
        someCars.fuel -= 10
        showRoom[name] = someCars
        
        print("Взял на тестдрайв машину \(name)")
    }
}

let clientTestDriveQueue = [
    "Иванов Иван Иванович": "BMW",
    "Петров Петр Петрович": "Tesla",
    "Сидоров Сидр Алкоголевич": "BMW",
]


func testdrive(client: String, cars: carShop) throws {
    let clientName = clientTestDriveQueue[client] ?? "BMW"
    try cars.errors(carName: clientName)
}

var client = carShop()
client.carFuelForTestDrive = 15

do {
    try testdrive(client: "Иванов Иван Иванович", cars: client)
} catch carError.noAvailableCar {
    print("Нет свободной машины")
} catch carError.noSuchCarInShop {
    print("Нет такой машины в автосалоне")
} catch carError.lowFuelLevel(let fuelNeed) {
    print("Недостаточно топлива для тестдрайва, заправьте машину еще на \(fuelNeed) литров топлива")
}
