//The code begins by selecting HTML elements with the IDs 'days', 'hours', 'mins', and 'sec'.
// These elements will be used to display the countdown values for each unit of time.

const daysEl = document.getElementById('days')
const hoursEl = document.getElementById('hours')
const minsEl = document.getElementById('mins')
const secEl = document.getElementById('sec')

//A constant named newYears is defined with the date set to '25 Jan 2024'.
// This is the target date for which the countdown is calculated.
const newYears = '25 Jan 2024';

//The countdown() function is defined. This function calculates the remaining time until
// the target date and updates the HTML content to display the countdown values.

// Inside the function, the current date and the target date are obtained using the Date object.
function countdown() {
    const newYearsDate = new Date(newYears);
    const currentDate = new Date();

//The difference between the target date and the current date is calculated in seconds and stored in totalSeconds.
//The totalSeconds value is then used to calculate the remaining time in terms of days, hours, minutes, and seconds.
    const totalSeconds = (newYearsDate - currentDate) / 1000;

    const days = Math.floor(totalSeconds / 3600 / 24);
    const hours = Math.floor(totalSeconds / 3600) % 24;
    const minutes = Math.floor(totalSeconds / 60) % 60;
    const seconds = Math.floor(totalSeconds) % 60;

    daysEl.innerHTML=formatTime(days);
    hoursEl.innerHTML=formatTime(hours);
    minsEl.innerHTML=formatTime(minutes);
    secEl.innerHTML = formatTime(seconds);
}
//The formatTime() function is called to ensure that the displayed 
//values are always in two-digit format. This function adds a leading zero if the time value is less than 10.
function formatTime(time) {
    return time < 10 ? `0${time}` : time;
}

//initial call
//The innerHTML property of the selected HTML elements is updated with the formatted countdown values.
countdown();
setInterval(countdown, 1000);