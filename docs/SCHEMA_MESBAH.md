
Neo4j mesbahv2 Schema
=====================

Container: neo4j_db (neo4j:2025.10.1-enterprise)
Database: mesbahv2

LABELS
------
Chunk : 30039 : text fragments (one per page)
Token : 96257 : extracted entities

RELATIONSHIPS
-------------
CONTAINS  : 307628 : Chunk -> Token
predicate : 222923 : Token -> Token  {name}
NEXT      :  29934 : Chunk -> Chunk
PREV      :  29934 : Chunk -> Chunk

CHUNK PROPERTIES
----------------
book_id : int
book_name : string
page_number : int
chunk_id : int
chunk_text : string (format "Metadata: ...\n-----\nContent: ...")
link : string (URL)
embedding : float[2560]

TOKEN PROPERTIES
----------------
name : string
type : string (Concept, Person, Group, ...)
label : string (always "Token")
embedding : float[2560]
id/data/link : NULL

INDEXES
-------
chunk_composite_index : RANGE on (book_id, page_number, chunk_id)
text_index_chunk : FULLTEXT on chunk_text
text_index_token : FULLTEXT on name
vector_index_chunk : VECTOR on embedding
vector_index_token : VECTOR on embedding

NOTES
-----
- type values appear in two languages (Concept + مفهوم). Two LLM runs likely.
- predicate.name also bilingual (related_to / مربوط_به).
