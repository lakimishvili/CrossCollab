//
//  AuthCoordinatorProtocol.swift
//  EventHub
//
//  Created by Bacho on 21.12.25.
//

protocol AuthCoordinatorProtocol: AnyObject {
    func navigate(to route: AuthRoute)
    func pop()
    func completeAuthentication()
}
