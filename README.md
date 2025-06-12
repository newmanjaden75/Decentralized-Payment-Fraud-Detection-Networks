# Decentralized Payment Fraud Detection Network

A blockchain-based system for detecting and preventing payment fraud using Clarity smart contracts.

## Overview

This project implements a decentralized payment fraud detection network using Clarity smart contracts. The system consists of multiple contracts that work together to detect, analyze, and prevent fraudulent payment activities.

## Components

### 1. Fraud Analyst Verification Contract

This contract manages the verification of fraud analysts who are authorized to participate in the network. It includes functionality to:

- Verify new analysts
- Revoke verification from existing analysts
- Check if an analyst is verified
- Transfer admin rights

### 2. Transaction Monitoring Contract

This contract monitors payment transactions for potential fraud. It includes functionality to:

- Record new transactions
- Flag transactions as potentially fraudulent
- Retrieve transaction details
- Check if a transaction is flagged

### 3. Pattern Recognition Contract

This contract manages known fraud patterns. It includes functionality to:

- Add new fraud patterns
- Update existing patterns
- Retrieve pattern details
- Get the total number of patterns

### 4. Alert Management Contract

This contract manages fraud alerts. It includes functionality to:

- Create new alerts
- Update alert status (open, investigating, resolved, false positive)
- Retrieve alert details
- Get the total number of alerts

### 5. Prevention Coordination Contract

This contract coordinates fraud prevention efforts. It includes functionality to:

- Create prevention actions (block address, freeze funds, enhanced monitoring)
- Deactivate prevention actions
- Check if an action is active
- Retrieve action details
- Get the total number of actions

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) for local development and testing
- Node.js and npm for running tests

### Installation

1. Clone the repository
2. Install dependencies:
