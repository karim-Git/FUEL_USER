//
//  OrdersModel.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 23/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class OrdersModel: NSObject {

    static let  sharedInstance = OrdersModel()
    var allOrders:[Order]? = []
    var pendingOrders:[Order]? = []

    var order = Order?()
    let model = Model.sharedInstance
    var isNextPage = false
    var orderLatitude:Double = 0.0
    var orderLongitude:Double = 0.0


    
    //MARK:API Request methods
    func orderWithOrderId(value:String, key:String) ->  Order?{
        
        
        let predicate = NSPredicate(format:"orderId == %@",value)
        let filterArr = self.allOrders?.filter({ predicate.evaluateWithObject($0)})
        if (filterArr?.count > 0) {
            return filterArr![0]
        }
        
        return nil
    }
    
    
    func requestForUserOrderList(pageCount:Int, success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void ) -> Void {
        
        ServiceModel.connectionWithBody(nil, method: GETMETHOD, service: "\(kGetOrders)/\(pageCount)", successBlock: { (response) in
            print(response)
            self.isNextPage = (response["isNextPage"] as? Bool)!

            if pageCount == 1
            {
                self.allOrders?.removeAll()
            }
            let totalOrders = response["result"] as! [AnyObject]
            for orderDict in totalOrders
            {
                var order = Order()
                order = order.initWithOrderInfo(orderDict as! [NSObject:AnyObject])
                self.allOrders?.append(order)
            }
          //  self.allOrders!.sortInPlace({ $0.updatedAt!.compare($1.updatedAt!) == .OrderedDescending })

            success(result: response)

        }) { (error) in
            
            failureBlock(error:error)
        }
    }
    
    
    func requestForOrderDetails(orderInfo:Order,success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(nil, method: GETMETHOD, service: "\(kOrderSave)/\(orderInfo.orderId!)", successBlock: { (response) in
            debug_print(response)

            success(result: response)
        }) { (error) in
            
            failureBlock(error:error)
        }

    }
    
    func requestForUserOrderListWithStatus(orderInfo:[NSObject:AnyObject]?,success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void ) -> Void {
        
        ServiceModel.connectionWithBody(nil, method: GETMETHOD, service: "\(kGetOrders)?status=New", successBlock: { (response) in
            debug_print(response)
            
            self.pendingOrders?.removeAll()
            
            let totalOrders = response["result"] as! [AnyObject]
            for orderDict in totalOrders
            {
                var order = Order()
                order = order.initWithOrderInfo(orderDict as! [NSObject:AnyObject])
                self.pendingOrders?.append(order)
            }
            success(result: response)
            
        }) { (error) in
            
            failureBlock(error:error)
        }

    }

    
    func requestForNewOrderForUser(orderInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void  {
        
        ServiceModel.connectionWithBody(orderInfo, method: POSTMETHOD, service: kOrderSave, successBlock: { (response) in
            let orderDict = response["result"] as! [NSObject:AnyObject]
            var order = Order()
            order = order.initWithOrderInfo(orderDict)
            self.order = order
            self.allOrders?.append(order)

            success(result: response)
            debug_print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }

    }
    
    
    func requestForUpdateOrder(orderInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(orderInfo, method: PUTMETHOD, service:"\(kOrderSave)/\(orderInfo[kOrderId]!)", successBlock: { (response) in
           
            success(result: response)

            let orderDict = response["result"] as! [NSObject:AnyObject]
            let updatedOrder = self.orderWithOrderId(orderInfo[kOrderId]! as! String,key:"orderId")
            if updatedOrder == nil
            {
                return
            }
            updatedOrder!.updateOrderWithInfo(orderDict)
            self.order = updatedOrder

            debug_print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }

    }
    
    
    func requestForDeleteOrder(orderInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(nil, method: DELETEMETHOD, service: "\(kOrderSave)/\(orderInfo[kOrderId])", successBlock: { (response) in
            
            success(result: response)
            debug_print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }

    }
    
    
    func requestForOrderEstimatedTime(locationInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void  {
        
        ServiceModel.connectionWithBody(locationInfo, method: POSTMETHOD, service: "\(kOrderSave)\(kGetOrderEstimatedTime)", successBlock: { (response) in
         
            print(response)
            success(result: response)
        }) { (error) in
            
            failureBlock(error:error)
        }

    }
    


}
