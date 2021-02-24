//
//  Result.swift
//  MVP
//
//  Created by home on 2021/02/20.
//  Copyright © 2021 Swift-beginners. All rights reserved.
//

public enum Result<T> {
    case success(T)
    case failure(Error)
}
