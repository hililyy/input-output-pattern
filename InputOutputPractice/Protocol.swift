//
//  Protocol.swift
//  InputOutputPractice
//
//  Created by 강조은 on 2024/01/19.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
