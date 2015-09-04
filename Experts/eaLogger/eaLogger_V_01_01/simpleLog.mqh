//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef FILELOGGER_HPP
#define FILELOGGER_HPP

//#include <fstream>
// Use the namespace you want
//namespace ige 

   class FileLogger 
     {

   public:

      // If you can´t/dont-want-to use C++11, remove the "class" word after enum
      enum e_logType { LOG_ERROR,LOG_WARNING,LOG_INFO };

      // ctor (remove parameters if you don´t need them)
      FileLogger(const char *engine_version,const char *fname="ige_log.txt")
                                                                       :   numWarnings(0U),
      numErrors(0U)
        {

         myFile.open(fname);

         // Write the first lines
         if(myFile.is_open()) 
           {
            myFile<<"My Game Engine, version "<<engine_version<<std::endl;
            myFile<<"Log file created"<<std::endl<<std::endl;
           } // if

        }

      // dtor
                       ~FileLogger() 
        {

         if(myFile.is_open()) 
           {
            myFile<<std::endl<<std::endl;

            // Report number of errors and warnings
            myFile<<numWarnings<<" warnings"<<std::endl;
            myFile<<numErrors<<" errors"<<std::endl;

            myFile.close();
           } // if

        }

      // Overload << operator using log type
      friend FileLogger &operator<<(FileLogger &logger,const e_logType l_type) 
        {

         switch(l_type) 
           {
            case ige::FileLogger::e_logType::LOG_ERROR:
               logger.myFile<<"[ERROR]: ";
               ++logger.numErrors;
               break;

            case ige::FileLogger::e_logType::LOG_WARNING:
               logger.myFile<<"[WARNING]: ";
               ++logger.numWarnings;
               break;

            default:
               logger.myFile<<"[INFO]: ";
               break;
           } // sw

         return logger;

        }

      // Overload << operator using C style strings
      // No need for std::string objects here
      friend FileLogger &operator<<(FileLogger &logger,const char *text) 
        {

         logger.myFile<<text<<std::endl;
         return logger;

        }

      // Make it Non Copyable (or you can inherit from sf::NonCopyable if you want)
                        FileLogger (const FileLogger &) = delete;
      FileLogger &operator= (const FileLogger &) = delete;



   private:

      std::ofstream     myFile;

      unsigned int      numWarnings;
      unsigned int      numErrors;

     }; // class end

#endif // FILELOGGER_HPP
