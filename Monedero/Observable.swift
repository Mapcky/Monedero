//
//  Observable.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 30/01/2025.
//

import Foundation

final class Observable<Input> {

    /** Main callback property after a binding is declared */
    private var callback: ((Input) -> Void)?
    
    /** Sets an observer (AnyObject Type) to listen over callbacks requested from another location. An input is required */
    func bind<Observer: AnyObject>(to observer: Observer, with callback: @escaping (Input) -> Void) {
        self.callback = { [weak observer] input in
            guard let _ = observer else {
                return
            }
            callback(input)
        }
    }

    /** Notifies the observer about any completion operation */
    func notify(with input: Input) {
        callback?(input)
    }

    init() { }
}

extension Observable where Input == Void {
    
    /** notifies the destination with no parameters (Input) */
    func notify() {
        callback?(())
    }

}
