//
//  ContentView.swift
//  Shared
//
//  Created by teenloong on 2022/8/2.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import Combine
import XWeatherKit


class ViewModel: ObservableObject {
    var cancells = Set<AnyCancellable>()
//    var disposeBag = DisposeBag()
    let location = XWDEBUGData.location
//    var weatherAction: CYWeatherNowAction {
//        CYWeatherNowAction(parameters: .init(token: token, longitude: location.longitude, latitude: location.latitude, alert: true))
//    }

//    var weatherAction: CYWeatherDetailAction {
//        CYWeatherDetailAction(parameters: .init(token: caiyunToken, longitude: location.longitude, latitude: location.latitude, alert: true, dailysteps: 5, hourlysteps: 24, lang: Locale.current.identifier, unit: .metric))
//    }
    
    var weatherAction: CYWeatherHourlyAction {
        CYWeatherHourlyAction(parameters: .init(token: caiyunToken, longitude: location.longitude, latitude: location.latitude, hourlysteps: 24))
    }
    
//    var weatherAction: QWeatherTopCititesAction {
//        QWeatherTopCititesAction(parameters: .init(range: Locale.current.regionCode?.lowercased(),lang: Locale.current.languageCode,key: qweatherKey))
//    }

    var caiyunToken: String = ""
    var qweatherKey: String = ""
    
    func setCaiYunToken(_ value: String) {
        caiyunToken = value
    }
    
    func setQWeatherKey(_ value: String) {
        qweatherKey = value
    }
    
    func requestCallBack() {
        XWeather.debug().request(action: weatherAction) { result in
            switch result {
            case .success(let response):
                #if DEBUG
                print(response)
                #endif
            case .failure(let error):
                #if DEBUG
                print(error)
                #endif
            }
        }
    }
    
    func requestObservable() {
//        XWeather.debug().requestObservable(action: weatherAction).subscribe(with: self) { owner, response in
//            #if DEBUG
//            print(response)
//            #endif
//        } onFailure: { owner, error in
//            #if DEBUG
//            print(error)
//            #endif
//        } onDisposed: { owner in
//            
//        }
//        .disposed(by: disposeBag)
    }
    
    func requestPublisher() {
        XWeather.debug().requestPublisher(action: weatherAction).sink { completion in
            if case .failure(let error) = completion {
#if DEBUG
                print(error)
#endif
            }
        } receiveValue: { response in
            #if DEBUG
            print(response)
            #endif
        }.store(in: &cancells)
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func requestAsync() {
        Task {
            let result = await XWeather.debug().requestAsync(action: weatherAction)
            await MainActor.run {
                switch result {
                case .success(let response):
                    #if DEBUG
                    print(response)
                    #endif
                case .failure(let error):
                    #if DEBUG
                    print(error)
                    #endif
                }
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject private var viewModel = ViewModel()
    @AppStorage("caiyuntoken") private var caiyunToken: String = ""
    @AppStorage("qweatherkey") private var qweatherKey: String = ""

    var body: some View {
        VStack {
            TextField("Cai Yun Token", text: $caiyunToken)
                .textFieldStyle(.roundedBorder)
                .onChange(of: caiyunToken) { newValue in
                    viewModel.setCaiYunToken(newValue)
                }
            TextField("QWeather Key", text: $qweatherKey)
                .textFieldStyle(.roundedBorder)
                .onChange(of: caiyunToken) { newValue in
                    viewModel.setQWeatherKey(newValue)
                }
            Button {
                viewModel.requestCallBack()
            } label: {
                Text("Request Callback")
            }
            Button {
                viewModel.requestObservable()
            } label: {
                Text("Request Observable")
            }
            Button {
                viewModel.requestPublisher()
            } label: {
                Text("Request Publisher")
            }
            Button {
                if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
                    viewModel.requestAsync()
                } else {
                    // Fallback on earlier versions
                }
            } label: {
                Text("Request Async")
            }
        }
        .padding()
        .onAppear {
            viewModel.setCaiYunToken(caiyunToken)
            viewModel.setQWeatherKey(qweatherKey)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
