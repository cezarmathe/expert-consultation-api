package com.code4ro.legalconsultation.service.impl;

import com.code4ro.legalconsultation.model.persistence.DocumentPdfFile;
import com.code4ro.legalconsultation.repository.DocumentPdfFileRepository;
import com.code4ro.legalconsultation.service.api.StorageApi;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.logging.Logger;

@Service
public class DocumentPdfFileService {
    
    private final DocumentPdfFileRepository documentPdfFileRepository;
    private final StorageApi storageApi;

    @Autowired
    public DocumentPdfFileService(final DocumentPdfFileRepository documentPdfFileRepository,
                                  final StorageApi storageApi) {
        this.documentPdfFileRepository = documentPdfFileRepository;
        this.storageApi = storageApi;
    }
    
    public DocumentPdfFile create(String state, MultipartFile document) {
        if (documentPdfFileRepository.existsByHash(document.hashCode())) {
            throw new RuntimeException("PDF file already exists"); // FIXME: 5/23/20 proper exception
        }
        String filePath;
        try {
            filePath = storageApi.storeFile(document);
        } catch (Exception e) {
            Logger.getGlobal().warning("Failed to store file: " + e.toString()); // FIXME: 5/23/20 probably not right
            return null; // FIXME: 5/23/20 probably not right
        }

        DocumentPdfFile documentPdfFile = new DocumentPdfFile();
        documentPdfFile.setFilePath(filePath);
        documentPdfFile.setState(state);
        documentPdfFile.setTimestamp(DateTime.now());
        documentPdfFile.setHash(document.hashCode());
        return documentPdfFileRepository.save(documentPdfFile);
    }
}
