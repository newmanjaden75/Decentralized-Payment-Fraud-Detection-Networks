import { describe, it, expect, beforeEach } from "vitest"

// Mock implementation for testing Clarity contracts
const mockContract = () => {
  let admin = "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM"
  const verifiedAnalysts = new Map()
  
  return {
    getAdmin: () => admin,
    verifyAnalyst: (caller: string, analyst: string) => {
      if (caller !== admin) return { error: 100 }
      if (verifiedAnalysts.has(analyst)) return { error: 101 }
      verifiedAnalysts.set(analyst, true)
      return { value: true }
    },
    revokeVerification: (caller: string, analyst: string) => {
      if (caller !== admin) return { error: 100 }
      if (!verifiedAnalysts.has(analyst)) return { error: 102 }
      verifiedAnalysts.delete(analyst)
      return { value: true }
    },
    isVerified: (analyst: string) => {
      return { value: verifiedAnalysts.has(analyst) }
    },
    transferAdmin: (caller: string, newAdmin: string) => {
      if (caller !== admin) return { error: 100 }
      admin = newAdmin
      return { value: true }
    },
  }
}

describe("Fraud Analyst Verification Contract", () => {
  let contract: ReturnType<typeof mockContract>
  
  beforeEach(() => {
    contract = mockContract()
  })
  
  it("should verify an analyst", () => {
    const admin = contract.getAdmin()
    const analyst = "ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG"
    
    const result = contract.verifyAnalyst(admin, analyst)
    expect(result).toEqual({ value: true })
    
    const verificationStatus = contract.isVerified(analyst)
    expect(verificationStatus).toEqual({ value: true })
  })
  
  it("should not allow non-admin to verify an analyst", () => {
    const nonAdmin = "ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG"
    const analyst = "ST3NBRSFKX28FQ2ZJ1MAKX58HKHSDGNV5N7R21XCP"
    
    const result = contract.verifyAnalyst(nonAdmin, analyst)
    expect(result).toEqual({ error: 100 })
  })
  
  it("should revoke verification", () => {
    const admin = contract.getAdmin()
    const analyst = "ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG"
    
    contract.verifyAnalyst(admin, analyst)
    const result = contract.revokeVerification(admin, analyst)
    expect(result).toEqual({ value: true })
    
    const verificationStatus = contract.isVerified(analyst)
    expect(verificationStatus).toEqual({ value: false })
  })
  
  it("should transfer admin rights", () => {
    const oldAdmin = contract.getAdmin()
    const newAdmin = "ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG"
    
    const result = contract.transferAdmin(oldAdmin, newAdmin)
    expect(result).toEqual({ value: true })
    
    // Old admin should no longer have privileges
    const verifyResult = contract.verifyAnalyst(oldAdmin, "ST3NBRSFKX28FQ2ZJ1MAKX58HKHSDGNV5N7R21XCP")
    expect(verifyResult).toEqual({ error: 100 })
    
    // New admin should have privileges
    const newVerifyResult = contract.verifyAnalyst(newAdmin, "ST3NBRSFKX28FQ2ZJ1MAKX58HKHSDGNV5N7R21XCP")
    expect(newVerifyResult).toEqual({ value: true })
  })
})
