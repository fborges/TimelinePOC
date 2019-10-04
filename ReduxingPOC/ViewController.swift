//
//  ViewController.swift
//  ReduxingPOC
//
//  Created by Felipe Borges Bezerra on 19/09/19.
//  Copyright © 2019 Felipe Borges Bezerra. All rights reserved.
//

import UIKit

let mainStore = Store<AppState>(
    reducer: allReducers,
    initialState: AppState(counter: 0, color: .white))

class ViewController: UIViewController, Subscriber {
    typealias State = AppState
    @IBOutlet weak var slider: UISlider!
    
    func newState(_ state: ViewController.State) {
        counterLabel.text = "\(state.counter)"
        view.backgroundColor = state.color
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainStore.subscribe(self)
    }

    
    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStore.slider = self.slider
        slider.minimumValue = 0
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        let index  = floor(sender.value)
        mainStore.dispatch(index: Int(index))
    }
    
    @IBAction func increaseTapped(_ sender: Any) {
        mainStore.dispatch(
            action: CounterAction.increase
        )
    }
    
    @IBAction func decreaseTapped(_ sender: Any) {
        mainStore.dispatch(
            action: CounterAction.decrease
        )
    }
    
    @IBAction func redTapped(_ sender: Any) {
        mainStore.dispatch(
            action: ColorAction.red
        )
    }
    
    @IBAction func blueTapped(_ sender: Any) {
        mainStore.dispatch(
            action: ColorAction.blue
        )
    }
}

struct AppState: ReduxState {
    var counter: Int
    var color: UIColor
}

enum CounterAction: Action {
    case increase, decrease
}

enum ColorAction: Action {
    case red, blue
}

let counterReducer: Reducer<AppState> = {( state, action) -> AppState in
    var state = state
    guard let counterAction = action as? CounterAction else {
        return state
    }
    
    switch counterAction {
    case .increase:
        state.counter += 1
    case .decrease:
        state.counter -= 1
    }
    
    return state
}

let colorReducer: Reducer<AppState> = {(state, action) -> AppState in
    var state = state
    guard let colorAction = action as? ColorAction else {
        return state
    }
    
    switch colorAction {
    case .red:
        state.color = .red
    case .blue:
        state.color = .blue
    }
    
    return state
}

let allReducers: Reducer<AppState> = {(state, action) -> AppState in
    var state = state
    state = colorReducer(state, action)
    state = counterReducer(state, action)
    return state
}
