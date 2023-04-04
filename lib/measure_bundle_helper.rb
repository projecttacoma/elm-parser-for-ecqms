# frozen_string_literal: true

class MeasureBundleHelper
  def get_files_from_bundle(bundle)
    if bundle == 'qdm'
      measure_list_from_qdm_bundle(bundle)
    elsif %w[fhir qicore].include?(bundle)
      measure_list_from_fhir_bundle(bundle)
    end
  end

  def measure_list_from_qdm_bundle(bundle)
    measure_list = []
    Dir.foreach("measures/#{bundle}") do |measure_filename|
      next if (measure_filename == '.') || (measure_filename == '..') || (measure_filename == '.DS_Store')

      file_hash = { measure_folder: measure_filename, root: '', supporting_files: [] }
      # Do work on the remaining files & directories
      Dir.foreach("measures/#{bundle}/#{measure_filename}") do |filename|
        next if (filename == '.') || (filename == '..') || (measure_filename == '.DS_Store')

        if root_filename?(filename, bundle)
          file_hash[:root] = filename
        elsif elm_filename?(filename, bundle)
          file_hash[:supporting_files] << filename
        end
      end
      measure_list << file_hash
    end
    measure_list
  end

  def measure_list_from_fhir_bundle(bundle)
    measure_list = []
    Dir.foreach("measures/#{bundle}/measures") do |measure_filename|
      next if (measure_filename == 'supporting') || (measure_filename == '.') || (measure_filename == '..') || (measure_filename == '.DS_Store')

      file_hash = { measure_folder: 'measures', root: measure_filename, supporting_files: [] }
      # Do work on the remaining files & directories
      Dir.foreach("measures/#{bundle}/measures/supporting") do |filename|
        next if (filename == '.') || (filename == '..') || (measure_filename == '.DS_Store')

        file_hash[:supporting_files] << "supporting/#{filename}"
      end
      measure_list << file_hash
    end
    measure_list
  end

  def root_filename?(filename, _bundle)
    filename.include?('CMS') && filename.include?('xml') && filename.include?('QDM') && !filename.include?('eCQM')
  end

  def elm_filename?(filename, _bundle)
    filename.include?('xml') && filename.include?('QDM') && !filename.include?('eCQM')
  end
end
