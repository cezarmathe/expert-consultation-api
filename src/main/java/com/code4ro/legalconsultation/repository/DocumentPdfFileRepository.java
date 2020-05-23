package com.code4ro.legalconsultation.repository;

import com.code4ro.legalconsultation.model.persistence.DocumentPdfFile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface DocumentPdfFileRepository extends JpaRepository<DocumentPdfFile, UUID> {
    DocumentPdfFile findByHash(String hash);
    DocumentPdfFile findByState(String state);
}
