# Decentralized Public Animal Control Lost Pet Database

A blockchain-based system for managing lost and found pets, facilitating reunions between pets and their owners through decentralized smart contracts.

## System Overview

This system consists of five interconnected Clarity smart contracts that work together to create a comprehensive lost pet management platform:

### Core Contracts

1. **Pet Registration Contract** (`pet-registration.clar`)
    - Maintains a comprehensive database of registered pets
    - Stores pet information, owner details, and microchip data
    - Tracks lost/found status updates

2. **Owner Notification Contract** (`owner-notification.clar`)
    - Manages communication between finders and owners
    - Creates notification records when pets are found
    - Handles contact information securely

3. **Shelter Coordination Contract** (`shelter-coordination.clar`)
    - Manages temporary care placement for found animals
    - Tracks shelter capacity and availability
    - Coordinates animal transfers between facilities

4. **Reunion Facilitation Contract** (`reunion-facilitation.clar`)
    - Orchestrates the pet return process
    - Verifies owner identity before reunion
    - Records successful reunions for system metrics

5. **Microchip Scanning Contract** (`microchip-scanning.clar`)
    - Processes microchip scan data
    - Links scanned chips to registered pets
    - Triggers notification workflows

## Key Features

- **Decentralized Database**: All pet records stored on blockchain
- **Privacy Protection**: Sensitive owner information encrypted
- **Automated Notifications**: Smart contract-triggered alerts
- **Shelter Integration**: Seamless coordination with animal shelters
- **Microchip Support**: Advanced pet identification technology
- **Verification System**: Secure owner identity confirmation

## Data Structures

### Pet Record
- Pet ID (unique identifier)
- Owner principal
- Pet name and description
- Microchip ID
- Status (registered, lost, found, reunited)
- Registration timestamp

### Notification Record
- Notification ID
- Pet ID reference
- Finder information
- Location found
- Timestamp
- Status (pending, contacted, resolved)

### Shelter Record
- Shelter ID
- Shelter name and location
- Capacity information
- Contact details
- Current animals housed

## Security Features

- **Owner Verification**: Multi-step identity confirmation
- **Access Control**: Role-based permissions system
- **Data Integrity**: Immutable blockchain records
- **Privacy Protection**: Encrypted sensitive information

## Usage Flow

1. **Registration**: Pet owners register their animals with complete information
2. **Loss Reporting**: Owners report pets as lost, updating status
3. **Finding**: Good Samaritans report found animals with location data
4. **Scanning**: Microchip scans automatically identify pets
5. **Notification**: System alerts owners when their pets are found
6. **Shelter Coordination**: Temporary care arranged if needed
7. **Reunion**: Verified owners reunited with their pets

## Benefits

- **Community-Driven**: Leverages public participation
- **Transparent**: All actions recorded on blockchain
- **Efficient**: Automated processes reduce manual work
- **Scalable**: Can handle large volumes of pets and users
- **Reliable**: Decentralized system with no single point of failure

## Getting Started

1. Deploy all five contracts to Stacks blockchain
2. Initialize system parameters and admin roles
3. Register shelters and authorized scanners
4. Begin accepting pet registrations
5. Activate notification and reunion workflows

## Testing

The system includes comprehensive tests using Vitest to ensure all contract functions work correctly and handle edge cases properly.

## Future Enhancements

- Mobile app integration for easier reporting
- GPS tracking integration
- Reward system for successful reunions
- Integration with veterinary clinics
- Multi-language support for broader adoption
