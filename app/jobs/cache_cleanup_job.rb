class CacheCleanupJob < ApplicationJob
  queue_as :default

  LIMIT = 1000
  
  def perform(*args)
    # Compose SQL directly instead of using ActiveRecord#delete_all, since #delete_all cannot handle
    # a limit. The limit, along with the order clause, are to be extra careful to make sure the queries stay
    # in check. 
    time = (Time.now.utc - ProductSearcher::CACHE_TTL).to_s(:db)
    sql = "DELETE FROM search_result_pages WHERE updated_at < '#{time}' ORDER BY updated_at LIMIT #{LIMIT}"

    # Use #exec_delete instead of #execute. Don't know why, but #execute will not return the number of rows deleted.
    rows_deleted = SearchResultPage.connection.exec_delete(sql, '', [])
    if rows_deleted >= LIMIT
      logger.info("Cleaned #{rows_deleted} rows out of cache, but might be more. Trying again.")
      CacheCleanupJob.perform_later
    end
  end
end
