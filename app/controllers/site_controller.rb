class SiteController < ApplicationController
  def dashboard
    render :index
  end

  def generate_site_url
    @site = SiteUrl.new
    @site.long_url = params["long_url"]
    @site.hash_code = SiteHelper.get_uniq_hashcode
    unless @site.save
      redirect_to dashboard_path, flash: {validation_errors: @site.errors.to_a}
      return
    end
    redirect_to generated_result_path(params.merge({code: @site.hash_code}))
  end

  def generated_result
    render :result
  end

  def short_site_url
    # check if present in cache
    # else look in database and save in cache (technique: cache aside)
    url_hash_code = params["code"]
    if url_hash_code.blank?
      # TODO: need to write a way to handle
      return false
    end

    # if present in cache, redirect directly
    # else look for it in main database
    if Cache::Redis.contains_data?(url_hash_code)
      site_url = Cache::Redis.get_data(url_hash_code)
    else
      record = SiteUrl.where(hash_code: url_hash_code).first
      site_url = record.long_url

      # save in cache
      Cache::Redis.store_data(url_hash_code, site_url)
    end
    redirect_to site_url, allow_other_host: true
  end

end
