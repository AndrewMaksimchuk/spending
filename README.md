# Receipt example

```txt
atb
18.07.2023 18:23:33
243.71
=
молоко
батон
морозиво
=
image=image_name_of_receipt_example_atb.26.09.2022.15.29.32.jpg
category=лікування
```

First 3 lines is required,  
all next, from line separetion(symbol =), is optional.

Image of receipt must be saved to
`project_directory/receipts_images` directory.  
The best image name is: shop_name.date.time,
like in example above.

To link the photo and the check together, write keyword `image=`  
and write name of the photo(example above).

For add category to the check, write keyword `category=`  
and write category name as in example above.

## Install

Run script `./install.bash` with `sudo` to see  
steps + create simlynk + shell completion(bash/zsh).

- Add to yout shell config file:  
  "SPENDING_INSTALL=path_to_this_directory"
- Then add "export PATH=$PATH:$SPENDING_INSTALL"
- Save and reload config file.
- Now you have 'spending' application.

## Service web server Node.js

You can run web server as `systemd` service.  
The service file is `spending.service`

### Commands for use service

`web_server_start` - start web server as service
`web_server_stop`  - stop web server as service

### systemctl commands

- Make systemd aware of the new service: sudo systemctl daemon-reload
- Make the service start on boot: sudo systemctl enable spending
- Start it with: systemctl start spending
- See logs with: journalctl -u spending

## Usage

See [usage](usage.md)

## Additional functions

### Validation

- store name
- date and time
- price
- chunk delimeter

#### Run only from this project directory

`show_last_n_days.bash` - Show last added  
receipts n days ago

## Use R programming language

Show list of installed libraries: `installed.packages()`  
Install dplyr library use: `install.packages("tidyverse")` in R REPL.  
Description of library: <https://cran.r-project.org/web/packages/dplyr/vignettes/base.html>
Example of graph: <https://r-graph-gallery.com/37-barplot-with-number-of-observation.html>
Example of R code: <https://github.com/PacktPublishing/R-Programming-By-Example/blob/master/Chapter03/vectorized_vs_unvectorized.R>

- [x] price min mean max values for all period
- [x] price min mean max values for all each month in selected year
- [x] count for each month hom much time go to shop(spend money) and total in selected year
- [x] count what shop is most visited 
- [ ] what category of stuff most buy // after all receipts have category // check for this condition
- [x] price count range for each month in selected year 
- [x] for each shop count min max mean of price for each month and total in selected year

## Statistics description(how to understand)

### Frequency table

Frequency means the number of times a value  
appears in the data. A table can quickly show us  
how many times each value appears.

### Relative frequency table

Relative frequency means the number of times a  
value appears in the data compared to the total  
amount. A percentage is a relative frequency.

### Cumulative frequency table

Cumulative frequency counts up to a particular  
value.

### Mean

The mean is usually referred to as 'the average'.

### Median

The median is the middle value in a data set  
ordered from low to high.

### Range

The range is the difference between the smallest  
and the largest value of the data.  
Range is the simplest measure of variation.
