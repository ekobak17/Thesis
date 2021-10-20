//
//  WalkViewController.swift
//  MovementTrackerApp
//
//  Created by Ellie Kobak on 10/12/21.
//


import UIKit
import CoreMotion
import Foundation

import MQTTKit

//let mqttConfig = MQTTConfig(clientId: "client_cid", host: "host",
//                  port: port, keepAlive: 60)
            
class WalkViewController: UIViewController {
    
    let motion = CMMotionManager()
    let MQTT_HOST = "/usr/local/etc/mosquitto/mosquitto.conf."
    let MQTT_PORT: UInt32 = 1883
    
    var timer = Timer()
    
    override func viewDidLoad() {
           super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        var timer:Timer?
        var timeLeft = 60 * 10.0 //10 minute timer
        
        mqttClient.publishString("Walking in Place", topic: "topic_Walking", qos: 2, retain: false)
        
        let AccelData = "Walking Data".data(using: .utf8)!
        mqtt.publish(to: "/appData/Walking", payload: AccelData, qos: .QoS0, retained: false)
        
        var accelerometerTimer = NSTimer.scheduledTimerWithTimeInterval(600.0, target: self, userInfo: nil, repeats: false);
        
        print(accelerometerTimer);
        
        motion.accelerometerUpdateInterval = 0.2
        self.timer = Timer(fire: Date(), interval: (0.2/60),
            repeats: true, block: { (timer) in
              // Get the accelerometer data.
              if let data = self.motion.accelerometerData {
                 let x = data.acceleration.x
                 let y = data.acceleration.y
                 let z = data.acceleration.z
              }
                
                mqtt.publish(to: "/appData/Walking", payload: x, qos: .QoS2, retained: false)
                mqtt.publish(to: "/appData/Walking", payload: y, qos: .QoS2, retained: false)
                mqtt.publish(to: "/appData/Walking", payload: z, qos: .QoS2, retained: false)
            })
       
        
        mqtt.didRecieveMessage = {mqtt, message in
          print(message)
        }
          }
        
}

        /*self.session?.delegate = self
                 self.transport.host = MQTT_HOST
                 self.transport.port = MQTT_PORT
                 session?.transport = transport

                 self.setUIStatus(for: self.session?.status ?? .created)
                 session?.connect() { error in
                     print("connection completed with status \(String(describing: error))")
                     if error != nil {
                         self.setUIStatus(for: self.session?.status ?? .created)
                     } else {
                         self.setUIStatus(for: self.session?.status ?? .error)
                     }
                 } */



