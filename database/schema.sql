USE banking_transaction_db;

CREATE TABLE customers (
    customer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(15) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


CREATE TABLE accounts (
    account_id VARCHAR(30) PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    balance DECIMAL(19,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_account_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT chk_account_balance
        CHECK (balance >= 0),

    CONSTRAINT chk_account_status
        CHECK (status IN ('ACTIVE', 'INACTIVE', 'BLOCKED'))

) ENGINE=InnoDB;


CREATE TABLE bank_transactions (
    transaction_id VARCHAR(64) PRIMARY KEY,
    transaction_type VARCHAR(20) NOT NULL,

    requested_amount DECIMAL(19,2) NOT NULL,
    amount DECIMAL(19,2) NULL,

    source_account_id VARCHAR(30),
    destination_account_id VARCHAR(30),

    requested_source_account VARCHAR(30),
    requested_destination_account VARCHAR(30),

    status VARCHAR(20) NOT NULL DEFAULT 'PROCESSING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transaction_source
        FOREIGN KEY (source_account_id)
        REFERENCES accounts(account_id),

    CONSTRAINT fk_transaction_destination
        FOREIGN KEY (destination_account_id)
        REFERENCES accounts(account_id),

    CONSTRAINT chk_transaction_amount
        CHECK (amount IS NULL OR amount > 0),

    CONSTRAINT chk_transaction_type
        CHECK (transaction_type IN ('DEPOSIT', 'WITHDRAWAL', 'TRANSFER')),

    CONSTRAINT chk_transaction_status
        CHECK (status IN ('PROCESSING', 'SUCCESS', 'FAILED', 'REJECTED'))

) ENGINE=InnoDB;


CREATE TABLE transaction_audit (
    audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(64) NOT NULL,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_audit_transaction
        FOREIGN KEY (transaction_id)
        REFERENCES bank_transactions(transaction_id)

) ENGINE=InnoDB;


CREATE TABLE failed_transactions (
    failure_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(64) NOT NULL,
    failure_category VARCHAR(50) NOT NULL,
    failure_reason VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_failed_transaction
        FOREIGN KEY (transaction_id)
        REFERENCES bank_transactions(transaction_id)

) ENGINE=InnoDB;
