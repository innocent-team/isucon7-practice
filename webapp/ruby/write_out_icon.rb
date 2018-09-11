require 'mysql2'

def db
  return @db_client if defined?(@db_client)

  @db_client = Mysql2::Client.new(
    host: ENV.fetch('ISUBATA_DB_HOST') { 'localhost' },
    port: ENV.fetch('ISUBATA_DB_PORT') { '3306' },
    username: ENV.fetch('ISUBATA_DB_USER') { 'isucon' },
    password: ENV.fetch('ISUBATA_DB_PASSWORD') { 'isucon' },
    database: 'isubata',
    encoding: 'utf8mb4'
  )
  @db_client.query('SET SESSION sql_mode=\'TRADITIONAL,NO_AUTO_VALUE_ON_ZERO,ONLY_FULL_GROUP_BY\'')
  @db_client
end

DEST = '/home/isucon/isucon7-practice/webapp/public/icons'
CHUNK_SIZE = 100
cnt = 0

loop {
  puts "chunk #{cnt}"
  stmt = db.prepare(%|
    select name, data
    from image
    order by id
    limit ? offset ?
  |)
  rows = stmt.execute(CHUNK_SIZE, cnt * CHUNK_SIZE).to_a
  stmt.close
  break if rows.empty?

  rows.each { |r|
    destination = "#{DEST}/#{r['name']}"
    puts destination
    File.open(destination, 'wb') {|f|
      f.write(r['data'])
    }
  }

  cnt += 1
}
