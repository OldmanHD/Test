//
//  RSAPublicKeyExporter.swift
//  Test
//
//  Created by Андрей Пептюк on 25.11.2020.
//  Copyright © 2020 Андрей Пептюк. All rights reserved.
//

import UIKit
import Foundation

public class RSAPublicKeyExporter: RSAPublicKeyExporting {

  // ASN.1 identifier byte
  public let sequenceIdentifier: UInt8 = 0x30

  // ASN.1 AlgorithmIdentfier for RSA encryption: OID 1 2 840 113549 1 1 1 and NULL
  private let algorithmIdentifierForRSAEncryption: [UInt8] = [0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86,
    0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00]

  public init() {}

  public func toSubjectPublicKeyInfo(_ rsaPublicKey: Data) -> Data {
    let writer = SimpleASN1Writer()

    // Insert the ‘unwrapped’ DER encoding of the RSA public key
    writer.write([UInt8](rsaPublicKey))

    // Insert ASN.1 BIT STRING length and identifier bytes on top of it (as a wrapper)
    writer.wrapBitString()

    // Insert ASN.1 AlgorithmIdentifier bytes on top of it (as a sibling)
    writer.write(algorithmIdentifierForRSAEncryption)

    // Insert ASN.1 SEQUENCE length and identifier bytes on top it (as a wrapper)
    writer.wrap(with: sequenceIdentifier)

    return Data(writer.encoding)
  }
}
