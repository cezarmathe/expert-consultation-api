package com.code4ro.legalconsultation.model.persistence;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.joda.time.DateTime;

import javax.persistence.*;

/**
 * A DocumentPdfFile is a representation of a PDF file attached to a Document.
 */
@Entity
@Table(name = "document_pdf_file")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class DocumentPdfFile extends BaseEntity {

    /**
     * State of the document PDF file.
     */
    @Column(nullable = false)
    private String state;

    /**
     * File path inside AWS S3 to the actual PDF file.
     */
    @Column(nullable = false, unique = true)
    private String filePath;

    /**
     * Timestamp at which this document has been uploaded.
     */
    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private DateTime timestamp;

    // FIXME: 5/23/20 proper hash type?
    /**
     * A hash of this document to prevent duplication.
     */
    @Column(nullable = false, unique = true)
    private String hash;
}
