
module Query::Filters::PlayerFilters
  def filters(**kwargs)
    conditions = [ "1=1" ]
    @values = {}

    @filters.to_h.each do |key, value|
      case key
      when "name"
        conditions << "name LIKE :name"
        @values[:name] = "%#{value}%"
      when "min_level"
        conditions << "level >= :min_level"
        @values[:min_level] = value.to_i
      when "max_level"
        conditions << "level <= :max_level"
        @values[:max_level] = value.to_i
      when "min_score"
        conditions << "score >= :min_score"
        @values[:min_score] = value.to_i
      when "min_kills"
        conditions << "kills >= :min_kills"
        @values[:min_kills] = value.to_i
      else
      end
    end

    unless conditions.empty?
      @where_clause = conditions.join(" AND ")
      @where_clause.prepend("WHERE ") unless kwargs[:skip_where]
    end
  end
end
