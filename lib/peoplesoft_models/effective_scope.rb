require "active_support/time_with_zone"

module PeoplesoftModels
  module EffectiveScope
    COLUMNS = ["effdt", "effseq"]

    def effective(as_of = Date.today)
      table = self.arel_table
      eff_keys = self.effective_key_values(as_of).as(eff_keys_relation_alias)
      join_conditions = self.primary_keys.map { |key| table[key].eq(eff_keys[key]) }.reduce(:and)

      self.joins("INNER JOIN #{eff_keys.to_sql} ON #{join_conditions.to_sql}")
    end

    def effective_key_values(as_of = Date.today)
      if self.effective_keys.include?("effseq")
        self.effseq_values
      else
        self.effdt_values
      end
    end

    def effdt_values(as_of = Date.today)
      table = self.arel_table
      columns = self.non_effective_keys + [table[:effdt].maximum.as("effdt")]

      self.unscoped
          .select(columns)
          .where(table[:effdt].lteq(as_of))
          .group(self.non_effective_keys)
    end

    def effseq_values(as_of = Date.today)
        table = self.arel_table
        effdt_keys = self.effdt_values(as_of).as(effdt_relation_alias)
        join_columns = self.primary_keys - ["effseq"]
        join_conditions = join_columns.map { |key| table[key].eq(effdt_keys[key]) }.reduce(:and)

        self.unscoped
            .select(join_columns + [table[:effseq].maximum.as("effseq")])
            .joins("INNER JOIN #{effdt_keys.to_sql} ON #{join_conditions.to_sql}")
            .group(join_columns.map { |key| table[key] })
    end

    def effective_keys
      self.primary_keys & COLUMNS
    end

    def non_effective_keys
      self.primary_keys - COLUMNS
    end

    private

    def eff_keys_relation_alias
      "EFF_KEYS_#{self.table_name.gsub(/^.*\./, "")}"
    end

    def effdt_relation_alias
      "EFFDT_#{self.table_name.gsub(/^.*\./, "")}"
    end
  end
end
