//
//  NewStopWatchView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/9/23.
//

import SwiftUI

struct NewStopWatchView: View {
      @State var hours: Int = 0
      @State var minutes: Int = 0
      @State var seconds: Int = 0
      @State var realHour: Int = 0
      @State var timerIsPaused: Bool = true
      
      @State var timer: Timer? = nil
      
      var body: some View {
        VStack {
          Text("\(realHour):\(hours):\(minutes).\(seconds)")
                .font(.largeTitle)
          if timerIsPaused {
            HStack {
              Button(action:{
                  self.restartTimer()
                print("RESTART")
              }){
                Image(systemName: "backward.end.alt")
                      .foregroundColor(.white)
                      .font(.title)
                      .padding()
                      .background(Color.red)
                      .cornerRadius(10)
              }
              .padding(.all)
                withAnimation{
                    Button(action:{
                        self.startTimer()
                        print("START")
                    }, label: {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(100)
                    })
                    
                }
              .padding(.all)
            }
          } else {
            Button(action:{
              print("Pause")
              self.stopTimer()
            }){
              Image(systemName: "pause.fill")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(100)
            }
            .padding(.all)
          }
        }
      }
      
      func startTimer(){
        timerIsPaused = false
          timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ tempTimer in
              if self.seconds == 9 {
            self.seconds = 0
            if self.minutes == 59 {
              self.minutes = 0
              self.hours = self.hours + 1
            } else {
              self.minutes = self.minutes + 1
            }
          } else {
            self.seconds = self.seconds + 1
          }
              if self.hours == 59 && self.minutes == 59 && self.seconds == 9 {
                  self.seconds = 0
                  self.minutes = 0
                  self.hours = 0
                  self.realHour = self.realHour + 1
              }
        }
      }
      
      func stopTimer(){
        timerIsPaused = true
        timer?.invalidate()
        timer = nil
      }
    
    func restartTimer(){
      hours = 0
      minutes = 0
      seconds = 0
    }
}

struct NewStopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        NewStopWatchView()
    }
}
