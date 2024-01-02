//
//  HTTPStatus+isValid.swift
//
//
//  Created by Andreas Hård on 2023-12-28.
//

import Foundation
import Vapor

extension HTTPStatus {
    public func isClientError() -> Bool {
        return self == .badRequest ||
        self == .unauthorized ||
        self == .paymentRequired ||
        self == .forbidden ||
        self == .notFound ||
        self == .methodNotAllowed ||
        self == .notAcceptable ||
        self == .proxyAuthenticationRequired ||
        self == .requestTimeout ||
        self == .conflict ||
        self == .gone ||
        self == .lengthRequired ||
        self == .preconditionFailed ||
        self == .payloadTooLarge ||
        self == .uriTooLong ||
        self == .unsupportedMediaType ||
        self == .rangeNotSatisfiable ||
        self == .expectationFailed ||
        self == .imATeapot ||
        self == .misdirectedRequest ||
        self == .unprocessableEntity ||
        self == .locked ||
        self == .failedDependency ||
        self == .upgradeRequired ||
        self == .preconditionRequired ||
        self == .tooManyRequests ||
        self == .requestHeaderFieldsTooLarge ||
        self == .unavailableForLegalReasons
    }
    
    public func isServerError() -> Bool {
        self == .internalServerError ||
        self == .notImplemented ||
        self == .badGateway ||
        self == .serviceUnavailable ||
        self == .gatewayTimeout ||
        self == .httpVersionNotSupported ||
        self == .variantAlsoNegotiates ||
        self == .insufficientStorage ||
        self == .loopDetected ||
        self == .notExtended ||
        self == .networkAuthenticationRequired
    }
    
    public func isValid() -> Bool {
        return !isClientError() && !isServerError()
    }
}
