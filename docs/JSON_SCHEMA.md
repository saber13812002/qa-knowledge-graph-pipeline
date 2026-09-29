JSON Schema - 100_books_Falsafe_Siasi.json
==========================================

File: /root/100_books_Falsafe_Siasi.json
Size: 287 MB
Records: 100 books
Source: Elasticsearch export of OCR books

ROOT STRUCTURE
--------------
Array of 100 objects:
  { dap_code, page_count, pages[] }

BOOK FIELDS
-----------
- dap_code : string
- page_count : int
- pages : array of Page

PAGE FIELDS (50+ keys)
----------------------
TEXT:
  paragraph_text : main text, paragraphs split by \n\n
  line_text : line-by-line
  words_count, lines_count, blocks_count : int
  average_confidence : float 0..1

POSITION:
  _id : dap_code + "_" + page_number
  page_number, ocr_page_number, first_text_page_number : int
  document_type : "book_page"

BIBLIOGRAPHIC:
  title, subtitle, author, volume, edition_statement, uniform_title
  contributors : [{name, role}]
  corrector, editor, introduction_author : [string]
  subjects : [string]
  publisher, publication_place, publication_year, isbn, language
  material_size, materials_notes, call_number

LIBRARY:
  barcode, itemnumber, biblionumber, item_type_id, home_library_id
  collections : array
  metadata : {tagNNN_code_X: [string]}
  parvanehBook : {confirm, fields:[{db_title}]}

OCR SOURCE:
  source : {book_directory, ocr_file, text_directory}
  ocr_file_hash, ocr_file_size, ocr_file_modified_at
  indexing_run_id, indexed_at

STATS
-----
Total books: 100
Total pages: 32,295
Max pages: 1,001
Min pages: 1
Languages: ara, per

MAPPING TO NEO4J
----------------
book.dap_code -> Chunk.book_id
page.title -> Chunk.book_name
page.page_number -> Chunk.page_number
page._id or index -> Chunk.chunk_id
page.paragraph_text -> Chunk.chunk_text
empty -> Chunk.link
Qwen3-Embedding-4B -> Chunk.embedding (2560-dim)

Entities/relations must be extracted via LLM (not in JSON).
