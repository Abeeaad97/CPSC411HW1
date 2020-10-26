import Kitura
import Cocoa

let router = Router()

router.all("/ClaimService/add", middleware: BodyParser())

let dbObj = Database.getInstance()

router.post("/ClaimService/add"){
    request, response, next in
    let body = request.body
    let jObj = body?.asJSON
    
    if let jDict = jObj as? [String:String] {
        if let t = jDict["title"], let dat = jDict["date"] {
            let i = UUID()
            let sol = false
            let cObj = Claim(i: i.uuidString, t: t, dat: dat, sol: sol)
            ClaimDao().addClaim(cObj: cObj)
        }
    }
    response.send("The Claim record was inserted successfully.")
    next()
}

router.get("ClaimService/getAll"){
    request, response,  next in
    let cList = ClaimDao().getAll()
    
    let jsonData : Data = try JSONEncoder().encode(cList)
    
    let jsonStr = String(data: jsonData, encoding: .utf8)
    
    response.send(jsonStr)
    next()
    
}


Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()

